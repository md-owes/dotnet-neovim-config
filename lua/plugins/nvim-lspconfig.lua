--[[ ---------------------------------------------------------------------
  nvim-lspconfig + Mason - language servers, keymaps, diagnostics
  Repo: neovim/nvim-lspconfig (with mason-org/mason.nvim)

  WHAT IT IS
    The centre of the LSP setup. It enables every language server
    for this config through Neovim's native vim.lsp.config / enable
    API, installs the servers and tools with Mason, gives every
    server blink.cmp's completion capabilities, defines the buffer-
    local LSP keymaps on LspAttach, and sets the global diagnostic
    display. Roslyn (C#) and rust-analyzer are configured separately
    in roslyn.lua and rustaceanvim.lua - not in the servers table.

  WHY IT IS USEFUL
    - One place lists every language you get definitions, references,
      rename, code actions, hover and diagnostics for.
    - Mason installs and updates the servers and formatters, so a
      new machine reproduces the whole toolchain from this file.
    - Consistent keymaps: the same gd / gr / rename keys work in
      every language because they are set once, on LspAttach.

  HOW IT IS CONFIGURED HERE
    - Dependencies: mason.nvim (registries: the default mason-org
      registry plus github:Crashdummyy/mason-registry, which carries
      roslyn), mason-lspconfig.nvim, mason-tool-installer.nvim,
      j-hui/fidget.nvim (opts = {}), saghen/blink.cmp.
    - LspAttach autocmd, group 'modern-lsp-attach': buffer-local
      maps via a local map() helper, mostly through Snacks pickers:
        gd          Snacks lsp_definitions      gr  lsp_references
        gI          Snacks lsp_implementations  <leader>D type defs
        <leader>ds  document symbols            <leader>ws workspace symbols
        <leader>rn  vim.lsp.buf.rename          <leader>ca code action (n, x)
        gD          vim.lsp.buf.declaration
        ]d / [d     vim.diagnostic.jump with a float, next / prev
        <leader>uh  toggle inlay hints, only if the attached client
                    supports textDocument/inlayHint (native v0.12)
      Note core/keymaps.lua also maps gd / gr / gI / gy globally to
      the same Snacks pickers; the LspAttach versions are the
      buffer-local ones active once a server is attached.
    - Diagnostics: vim.diagnostic.config with virtual_text prefix
      (a vertical bar glyph), spacing 4, source 'if_many'; signs =
      true, underline = true, update_in_insert = false,
      severity_sort = true.
    - Capabilities: require('blink.cmp').get_lsp_capabilities()
      with offsetEncoding forced to { 'utf-16' }, deep-merged into
      every server's config before vim.lsp.config + vim.lsp.enable.
    - servers table (all {} = defaults unless noted):
        lua_ls - settings: completion.callSnippet = 'Replace',
                 diagnostics disabled: 'missing-fields'
                 (library setup itself comes from lazydev.nvim)
        astro, ts_ls, eslint, tailwindcss
        dockerls, docker_compose_language_service, postgres_lsp
        basedpyright - analysis.typeCheckingMode = 'basic',
                 autoSearchPaths, useLibraryCodeForTypes = true
        ruff, gopls, clangd, bashls
        html, cssls, jsonls, yamlls, taplo, marksman, lemminx,
        tinymist
    - Mason tools: ensure_installed = all server names above plus
      stylua, prettier, prettierd, csharpier, debugpy, roslyn,
      rust-analyzer, netcoredbg, js-debug-adapter, codelldb, delve,
      gopls, clangd, bash-language-server, html-lsp, css-lsp,
      json-lsp, yaml-language-server, taplo, marksman, lemminx,
      tinymist, shfmt, gofumpt, clang-format, shellcheck - the
      formatters conform.nvim runs and the adapters nvim-dap uses
      are installed from this same list.

  HOW TO INVOKE IT
    - Automatic: open a file of a supported type and its server
      starts; use gd, gr, <leader>rn, <leader>ca, K (default hover)
      and ]d / [d as listed above.
    - :LspInfo / :checkhealth vim.lsp - attached clients and logs.
    - :Mason - manage installed servers and tools; :MasonInstall,
      :MasonUpdate for manual changes (normally automatic).
    - <C-x> (from workspace-diagnostics.lua) forces servers to
      publish diagnostics for the whole workspace.

  FEATURES
    - Definitions, references, implementations, declarations,
      rename and code actions via Snacks pickers / native LSP.
    - Workspace and document symbol search in the picker.
    - Configured diagnostic signs, underlines and virtual text.
    - Inlay-hint toggling where a server supports it.
    - One-command toolchain install via Mason tool installer.
---------------------------------------------------------------------]]


return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{
			"mason-org/mason.nvim",
			opts = {
				registries = { "github:mason-org/mason-registry", "github:Crashdummyy/mason-registry" },
			},
		},
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "j-hui/fidget.nvim", opts = {} },
		"saghen/blink.cmp",
	},
	config = function()
		-- LspAttach autocommand for keymaps and highlights
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("modern-lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc, mode)
					vim.keymap.set(mode or "n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				-- Define standard LSP keymaps using Snacks Picker
				map("gd", function() Snacks.picker.lsp_definitions() end, "[G]oto [D]efinition")
				map("gr", function() Snacks.picker.lsp_references() end, "[G]oto [R]eferences")
				map("gI", function() Snacks.picker.lsp_implementations() end, "[G]oto [I]mplementation")
				map("<leader>D", function() Snacks.picker.lsp_type_definitions() end, "Type [D]efinition")
				map("<leader>ds", function() Snacks.picker.lsp_symbols() end, "[D]ocument [S]ymbols")
				map("<leader>ws", function() Snacks.picker.lsp_workspace_symbols() end, "[W]orkspace [S]ymbols")
				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

				-- Inlay hints (Native v0.12)
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
					map("<leader>uh", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					end, "[U]I: Toggle [H]ints")
				end

				-- Diagnostic jump keymaps (modern native approach)
				map("]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next Diagnostic")
				map("[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Prev Diagnostic")
			end,
		})

		-- Native diagnostic configuration
		vim.diagnostic.config({
			virtual_text = { prefix = "▎", spacing = 4, source = "if_many" },
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
		})

		-- Define servers to enable
		local servers = {
			lua_ls = {
				settings = {
					Lua = {
						completion = { callSnippet = "Replace" },
						diagnostics = { disable = { "missing-fields" } },
					},
				},
			},
			astro = {},
			ts_ls = {},
			eslint = {},
			tailwindcss = {},
			dockerls = {},
			docker_compose_language_service = {},
			postgres_lsp = {},
			basedpyright = {
				settings = {
					basedpyright = {
						analysis = {
							typeCheckingMode = "basic",
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
						},
					},
				},
			},
			ruff = {},
			gopls = {},
			clangd = {},
			bashls = {},
			html = {},
			cssls = {},
			jsonls = {},
			yamlls = {},
			taplo = {},
			marksman = {},
			lemminx = {},
			tinymist = {},
		}

		-- Setup Blink-integrated capabilities
		local capabilities = require("blink.cmp").get_lsp_capabilities()
		---@diagnostic disable-next-line: inject-field
		capabilities.offsetEncoding = { "utf-16" }

		-- Unified server configuration
		for server, config in pairs(servers) do
			config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
			vim.lsp.config(server, config)
			vim.lsp.enable(server)
		end

		-- Tools management
		local ensure_installed = vim.tbl_keys(servers)
		vim.list_extend(ensure_installed, { "stylua", "prettier", "prettierd", "csharpier", "debugpy", "roslyn", "rust-analyzer", "netcoredbg", "js-debug-adapter", "codelldb", "delve", "gopls", "clangd", "bash-language-server", "html-lsp", "css-lsp", "json-lsp", "yaml-language-server", "taplo", "marksman", "lemminx", "tinymist", "shfmt", "gofumpt", "clang-format", "shellcheck" })
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
	end,
}
