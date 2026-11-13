--[[ ---------------------------------------------------------------------
  avante.nvim - AI coding assistant in a sidebar
  Repo: avante-corp/avante.nvim

  WHAT IT IS
    An AI pair-programmer inside Neovim, similar to Cursor or Copilot Chat
    but running as a Neovim plugin. It opens a chat sidebar where you can
    ask questions about your code, request edits, generate new code, explain
    selections, fix errors and refactor, with access to your buffers, files
    and LSP context.

  WHY IT IS USEFUL
    - Chat about the code you are actually editing, without leaving Neovim.
    - Apply AI-proposed edits directly to buffers instead of copy-pasting.
    - Scope requests to a visual selection, a whole file, or files you
      mention in chat, so answers stay grounded in your codebase.
    - Iterate in one place: history stays in the sidebar while you refine
      a task, fix a bug, or work through a feature.

  HOW IT IS CONFIGURED HERE
    - Lazy-loaded on VeryLazy; version = false (tracks latest, never '*').
    - Build: 'make' on Unix, PowerShell Build.ps1 on Windows.
    - Provider: 'positionapi', inherited from the OpenAI provider:
        endpoint = https://positionapi.top/v1
        api_key_name = POSITION_API_KEY (read from the environment)
        model = gpt-6-astra
        use_response_api = true, support_previous_response_id = false
        extra_request_body.store = false - stateless Responses API:
        full history is sent in each request, nothing is stored server-side.
    - Selection hint display is 'delayed', so the hint is less noisy.
    - Sidebar: right side, width 40 columns, centred rounded header.
    - File selector for '@file' mentions: selector.provider = 'snacks'
      (the earlier default native selector could not reliably select
      files). All file types are listed - code, Markdown, text, images,
      PDF, Word and Excel.
    - Behaviour: support_paste_from_clipboard = true, with
      img-clip.nvim embedding pasted images as base64 (needs a
      vision-capable model).
    - Custom tool 'read_document' extracts readable text from binary
      documents (PDF, DOCX, XLSX, PPTX, ODT) via
      scripts/avante_extract_doc.py, because '@file' itself reads
      files as plain text. PDF extraction needs pdftotext (poppler)
      or the pypdf Python package; XLSX uses openpyxl.
    - No custom keymaps are defined in this file; use the commands below.
    - Completion sources for Avante (commands, mentions, files) are wired
      into blink.cmp - see lua/plugins/blink.lua.

  HOW TO INVOKE IT
    - :AvanteAsk [question]  - ask about the current selection or file.
    - :AvanteChat            - open the chat sidebar.
    - :AvanteToggle          - toggle the sidebar.
    - :AvanteEdit            - ask for an edit to the selection.
    - :AvanteFocus           - jump focus to the sidebar.
    - :AvanteStop / :AvanteClear - stop generation / clear history.
    - Visual-select code first, then :AvanteAsk or :AvanteEdit to scope
      the request to that selection. In chat use '@' mentions to add files
      to the context, e.g. '@file' to attach a file of any type.

  FEATURES
    - Sidebar chat with streaming responses and code blocks.
    - Apply / accept diffs for suggested edits.
    - File, buffer and diagnostics context via mentions and tools.
    - Tool use through the provider Responses API.
    - Markdown rendering in the chat via render-markdown.nvim
      (filetype 'Avante' - see lua/plugins/render-markdown.lua).

  DEPENDENCIES / REQUIREMENTS
    - nvim-lua/plenary.nvim, MunifTanjim/nui.nvim, folke/snacks.nvim,
      ColinKennedy/mega.cmdparse (+ mega.logging),
      HakonHarnes/img-clip.nvim (image paste).
    - Needs POSITION_API_KEY set in the environment.
    - Needs python3 for scripts/avante_extract_doc.py; openpyxl for
      XLSX, and pdftotext (poppler) or pypdf for PDF.
    - First install builds a native helper with 'make'.
]]

return {
	"avante-corp/avante.nvim",
	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	-- ⚠️ must add this setting! ! !
	build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
		or "make",
	event = "VeryLazy",
	version = false, -- Never set this value to "*"! Never!
	---@module 'avante'
	opts = {
		-- Basic provider configuration (valid options only)
		provider = "positionapi",

		providers = {
			positionapi = {
				__inherited_from = "openai",
				endpoint = "https://positionapi.top/v1",
				api_key_name = "POSITION_API_KEY",
				model = "gpt-6-astra",
								use_response_api = true,
								support_previous_response_id = false,
								extra_request_body = {
									store = false, -- Stateless Responses: full history goes in input, nothing is stored server-side
								},
			},
		},

		-- File selector for @file mentions: use the Snacks picker (already
		-- installed) instead of the default native selector, which cannot
		-- reliably list/select files. The picker lists all file types -
		-- code, Markdown, text, images, PDF, Word and Excel.
		selector = {
			provider = "snacks",
		},

		-- Behaviour: allow pasting images from the clipboard into chat
		-- (requires img-clip.nvim, added below, and a vision-capable
		-- model). Pasted images are embedded as base64.
		behaviour = {
			support_paste_from_clipboard = true,
		},

		-- Custom tool: extract text from binary documents. Avante's
		-- @file reads files as plain text, so PDF/DOCX/XLSX/PPTX/ODT
		-- would arrive as garbage. The model should call this tool
		-- for those extensions; it shells out to
		-- scripts/avante_extract_doc.py (stdlib ZIP/XML, openpyxl for
		-- .xlsx, pdftotext or pypdf for .pdf).
		custom_tools = {
			{
				name = "read_document",
				description = "Extract readable text from a binary document (PDF, DOCX, XLSX, PPTX, ODT). Use it whenever the user asks about such a file or mentions one with @file, instead of reading it as plain text.",
				param = {
					type = "table",
					fields = {
						{ name = "path", description = "Relative or absolute path to the document", type = "string" },
					},
					usage = { path = "Path to the document file" },
				},
				returns = {
					{ name = "content", description = "Extracted plain text of the document", type = "string" },
					{ name = "error", description = "Error message if extraction failed", type = "string", optional = true },
				},
				func = function(params, _opts)
					if not params.path or params.path == "" then
						return nil, "path is required"
					end
					local abs_path = vim.fn.fnamemodify(params.path, ":p")
					if vim.fn.filereadable(abs_path) == 0 then
						return nil, "File not found: " .. abs_path
					end
					local script = vim.fs.joinpath(vim.fn.stdpath("config"), "scripts", "avante_extract_doc.py")
					local result = vim.system({ "python3", script, abs_path }, { text = true }):wait()
					if result.code ~= 0 then
						return nil, vim.trim(result.stderr or "Failed to extract text")
					end
					return result.stdout, nil
				end,
			},
		},

		-- Recommended settings
		selection = {
			hint_display = "delayed",
		},

		-- Enhanced window configuration
		windows = {
			position = "right",
			width = 40,
			sidebar_header = {
				enabled = true,
				align = "center",
				rounded = true,
			},
		},
	},

	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"folke/snacks.nvim",
		{ "ColinKennedy/mega.cmdparse", dependencies = { "ColinKennedy/mega.logging" } },
		-- Image paste support for @file / clipboard images in Avante chat.
		{
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				default = {
					embed_image_as_base64 = true,
					prompt_for_file_name = false,
					drag_and_drop = { insert_mode = true },
					use_absolute_path = true,
				},
			},
		},
	},
}
