return { -- Fuzzy Finder (files, lsp, etc)
	"nvim-telescope/telescope.nvim",
	lazy = true,
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ -- If encountering errors, see telescope-fzf-native README for installation instructions
			"nvim-telescope/telescope-fzf-native.nvim",

			-- `build` is used to run some command when the plugin is installed/updated.
			-- This is only run then, not every time Neovim starts up.
			build = "make",

			-- `cond` is a condition used to determine whether this plugin should be
			-- installed and loaded.
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-telescope/telescope-ui-select.nvim" }, -- Useful for getting pretty icons, but requires a Nerd Font.
		{
			"nvim-tree/nvim-web-devicons",
			enabled = vim.g.have_nerd_font,
		},
	},
	keys = { -- Search for LSP definitions
		{
			"<leader>sa",
			"<cmd>Telescope lsp_definitions<cr>",
			desc = "[S]e[a]rch Definitions",
		}, -- Search for LSP references
		{
			"<leader>se",
			"<cmd>Telescope lsp_references<cr>",
			desc = "[S]earch R[e]ferences",
		}, -- Search for files in the current working directory
		{
			"<leader>sf",
			"<cmd>Telescope find_files<cr>",
			desc = "[S]earch [F]iles",
		}, -- Search for live grep results
		{
			"<leader>sg",
			"<cmd>Telescope live_grep<cr>",
			desc = "[S]earch Live [G]rep",
		}, -- Search for help tags
		{
			"<leader>sh",
			"<cmd>Telescope help_tags<cr>",
			desc = "[S]earch [H]elp",
		}, -- Search for LSP implementations
		{
			"<leader>si",
			"<cmd>Telescope lsp_implementations<cr>",
			desc = "[S]earch [I]mplementations",
		}, -- Search for keymaps
		{
			"<leader>sk",
			"<cmd>Telescope keymaps<cr>",
			desc = "[S]earch [K]eymaps",
		}, -- Search for LSP document symbols
		{
			"<leader>sl",
			"<cmd>Telescope lsp_document_symbols<cr>",
			desc = "[S]earch [L]SP Symbols",
		}, -- Search for LSP command history
		{
			"<leader>sm",
			"<cmd>Telescope lsp_incoming_calls<cr>",
			desc = "[S]earch Inco[m]ing Calls",
		}, -- Search for LSP command history
		{
			"<leader>so",
			"<cmd>Telescope lsp_outgoing_calls<cr>",
			desc = "[S]earch [O]utgoing Calls",
		}, -- Search for grep results
		{
			"<leader>sp",
			"<cmd>Telescope grep_string<cr>",
			desc = "[S]earch Gre[p]",
		}, -- Search for recent files
		{
			"<leader>sr",
			"<cmd>Telescope resume<cr>",
			desc = "[S]earch [R]esume",
		}, -- Search for all Telescope pickers
		{
			"<leader>ss",
			"<cmd>Telescope builtin<cr>",
			desc = "[S]earch [S]elect Telescope",
		}, -- Search for LSP type definitions
		{
			"<leader>st",
			"<cmd>Telescope lsp_type_definitions<cr>",
			desc = "[S]earch [T]ype Definitions",
		}, -- Search for LSP workspace symbols
		{
			"<leader>sw",
			"<cmd>Telescope lsp_workspace_symbols<cr>",
			desc = "[S]earch [W]orkspace Symbols",
		}, -- Search for LSP symbols
		{
			"<leader>sy",
			"<cmd>Telescope lsp_document_symbols<cr>",
			desc = "[S]earch S[y]mbols",
		}, -- Search for recent files
		{
			"<leader>s.",
			"<cmd>Telescope oldfiles<cr>",
			desc = "[S]earch [.]Recent Files",
		}, -- Search for used commands
		{
			"<leader>s,",
			"<cmd>Telescope commands<cr>",
			desc = "[S]earch [,]Commands",
		}, -- Search for buffers
		{
			"<leader><leader>",
			"<cmd>Telescope buffers<cr>",
			desc = "[ ] Search Buffers",
		}, -- Search for diagnostics
		{
			"<leader>sd",
			"<cmd>Telescope diagnostics<cr>",
			desc = "[S]earch [D]iagnostics",
		}, -- Search for LSP dynamic all workspace symbols
		{
			"<leader>sdw",
			"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
			desc = "[S]earch [D]ynamic [W]orkspace Symbols",
		}, -- Search for variables and symbols
		{
			"<leader>sts",
			"<cmd>Telescope treesitter<cr>",
			desc = "[S]earch [K]eymaps",
		}, -- Search for git files
		{
			"<leader>gf",
			"<cmd>Telescope git_files<cr>",
			desc = "Search [G]it [F]iles",
		}, -- Search for git status
		{
			"<leader>gs",
			"<cmd>Telescope git_status<cr>",
			desc = "Git Status",
		}, -- Search for git commits
		{
			"<leader>gl",
			"<cmd>Telescope git_commits<cr>",
			desc = "Git Log",
		}, -- Search for git stash
		{
			"<leader>gt",
			"<cmd>Telescope git_stash<cr>",
			desc = "Git Stash",
		}, -- Search for git branches
		{
			"<leader>gb",
			"<cmd>Telescope git_branches<cr>",
			desc = "Git Branches",
		}, -- Search for current buffer fuzzy find
		{
			"<leader>/",
			function()
				require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end,
			desc = "[/] Fuzzy Search in Buffer",
		},
		{
			"<leader>s/",
			function()
				require("telescope.builtin").live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end,
			desc = "[S]earch [/] in Open Files",
		}, -- Shortcut for searching your Neovim configuration files
		{
			"<leader>sn",
			function()
				require("telescope.builtin").find_files({
					cwd = vim.fn.stdpath("config"),
				})
			end,
			desc = "[S]earch [N]eovim files",
		},
	},
	config = function()
		-- Telescope is a fuzzy finder that comes with a lot of different things that
		-- it can fuzzy find! It's more than just a "file finder", it can search
		-- many different aspects of Neovim, your workspace, LSP, and more!
		--
		-- The easiest way to use Telescope, is to start by doing something like:
		--  :Telescope help_tags
		--
		-- After running this command, a window will open up and you're able to
		-- type in the prompt window. You'll see a list of `help_tags` options and
		-- a corresponding preview of the help.
		--
		-- Two important keymaps to use while in Telescope are:
		--  - Insert mode: <c-/>
		--  - Normal mode: ?
		--
		-- This opens a window that shows you all of the keymaps for the current
		-- Telescope picker. This is really useful to discover what Telescope can
		-- do as well as how to actually do it!

		local actions = require("telescope.actions")
		local action_state = require("telescope.actions.state")

		local function smart_open(prompt_bufnr)
			local entry = action_state.get_selected_entry()
			local path = entry.path or entry.filename
			actions.close(prompt_bufnr)

			if not path then
				return
			end

			-- Check if file is already open in any tab
			for _, tabnr in ipairs(vim.api.nvim_list_tabpages()) do
				for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabnr)) do
					local buf = vim.api.nvim_win_get_buf(win)
					local bufname = vim.api.nvim_buf_get_name(buf)
					if bufname == path then
						vim.cmd("tabnext " .. vim.api.nvim_tabpage_get_number(tabnr))
						return
					end
				end
			end

			-- Otherwise open in new tab
			vim.cmd("tabnew " .. vim.fn.fnameescape(path))
		end

		-- [[ Configure Telescope ]]
		-- See `:help telescope` and `:help telescope.setup()`
		require("telescope").setup({
			-- You can put your default mappings / updates / etc. in here
			--  All the info you're looking for is in `:help telescope.setup()`
			--
			defaults = {
				mappings = {
					-- i = { ["<c-enter>"] = "to_fuzzy_refine" },
					i = { -- Mappings for insert mode
						["<CR>"] = smart_open,
					},
					n = { -- Mappings for normal mode
						["<CR>"] = smart_open,
					},
				},
			},
			-- pickers = {}
			extensions = {
				["ui-select"] = { require("telescope.themes").get_dropdown() },
			},
		})

		-- Enable Telescope extensions if they are installed
		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")
	end,
}
