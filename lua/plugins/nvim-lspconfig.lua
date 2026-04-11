return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{
			"williamboman/mason.nvim",
			opts = {
				registries = { "github:mason-org/mason-registry", "github:Crashdummyy/mason-registry" },
			},
		},
		"williamboman/mason-lspconfig.nvim",
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
				map("]d", vim.diagnostic.goto_next, "Next Diagnostic")
				map("[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
			end,
		})

		-- Native diagnostic configuration
		vim.diagnostic.config({
			virtual_text = { prefix = "▎", spacing = 4, source = "if_nosource" },
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
		}

		-- Setup Blink-integrated capabilities
		local capabilities = require("blink.cmp").get_lsp_capabilities()
		capabilities.offsetEncoding = { "utf-16" }

		-- Unified server configuration
		for server, config in pairs(servers) do
			config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
			vim.lsp.config(server, config)
			vim.lsp.enable(server)
		end

		-- Tools management
		local ensure_installed = vim.tbl_keys(servers)
		vim.list_extend(ensure_installed, { "stylua", "prettier", "prettierd", "csharpier", "debugpy" })
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
	end,
}
