--[[ ---------------------------------------------------------------------
  conform.nvim - formatter runner (format on save + manual format)
  Repo: stevearc/conform.nvim

  WHAT IT IS
    A lightweight formatter plugin. It runs external formatters (stylua,
    prettierd, ruff, rustfmt and others) on the current buffer, either
    automatically when you save or on demand. It does not format anything
    itself - it finds the right formatter for the filetype and runs it,
    falling back to the LSP formatter when no external tool is set.

  WHY IT IS USEFUL
    - Every file is formatted consistently on save, with no manual step.
    - One place maps each language to its canonical formatter.
    - LSP fallback means files still get formatted even if a formatter
      binary is missing, except for languages where LSP formatting is
      deliberately disabled (see below).
    - Fast: format_on_save has a 500 ms timeout, so a slow formatter
      never blocks saving for long.

  HOW IT IS CONFIGURED HERE
    - Lazy-loaded on BufWritePre; command :ConformInfo is also available.
    - notify_on_error = false: formatter errors stay quiet.
    - format_on_save: timeout_ms = 500, lsp_format = 'fallback', except
      for C and C++ where lsp_format = 'never' (those languages have no
      well-standardised style, so only clang-format is used).
    - formatters_by_ft:
        lua -> stylua
        astro, javascript, javascriptreact, typescript, typescriptreact,
          json, jsonc, yaml, html, css, markdown -> prettierd
        csharp -> csharpier
        python -> ruff_format, ruff_organize_imports
        go -> gofumpt
        c, cpp -> clang-format
        sh, bash -> shfmt
        toml -> taplo
        rust -> rustfmt
    - Commented examples show running several formatters sequentially
      and 'stop_after_first' to use the first available formatter.
    - The formatter binaries are installed via Mason - see the
      ensure_installed list in lua/plugins/nvim-lspconfig.lua.

  HOW TO INVOKE IT
    - Automatic: just save with :w - the buffer is formatted first.
    - Manual: <leader>cf formats the current buffer asynchronously,
      with LSP fallback (desc: '[C]ode [F]ormat Buffer').
    - :ConformInfo shows which formatters apply to the current buffer
      and whether they are available.

  FEATURES
    - Per-filetype formatter lists, run in order.
    - LSP format fallback ('fallback' / 'never' / 'prefer').
    - Async formatting for the manual keymap, so Neovim stays responsive.
    - :ConformInfo diagnostics for debugging missing formatters.
---------------------------------------------------------------------]]


return { -- Autoformat
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		notify_on_error = false,
		format_on_save = function(bufnr)
			-- Disable "format_on_save lsp_fallback" for languages that don't
			-- have a well standardized coding style. You can add additional
			-- languages here or re-enable it for the disabled ones.
			local disable_filetypes = {
				c = true,
				cpp = true,
			}
			local lsp_format_opt
			if disable_filetypes[vim.bo[bufnr].filetype] then
				lsp_format_opt = "never"
			else
				lsp_format_opt = "fallback"
			end
			return {
				timeout_ms = 500,
				lsp_format = lsp_format_opt,
			}
		end,
		formatters_by_ft = {
			lua = { "stylua" },
			astro = { "prettierd" },
			csharp = { "csharpier" },
			javascript = { "prettierd" },
			javascriptreact = { "prettierd" },
			typescript = { "prettierd" },
			typescriptreact = { "prettierd" },
			python = { "ruff_format", "ruff_organize_imports" },
			go = { "gofumpt" },
			c = { "clang-format" },
			cpp = { "clang-format" },
			sh = { "shfmt" },
			bash = { "shfmt" },
			json = { "prettierd" },
			jsonc = { "prettierd" },
			yaml = { "prettierd" },
			html = { "prettierd" },
			css = { "prettierd" },
			markdown = { "prettierd" },
			toml = { "taplo" },
			rust = { "rustfmt" },
			-- Conform can also run multiple formatters sequentially
			-- python = { "isort", "black" },
			--
			-- You can use 'stop_after_first' to run the first available formatter from the list
			-- javascript = { "prettierd", "prettierd", stop_after_first = true },
		},
	},
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({
					async = true,
					lsp_format = "fallback",
				})
			end,
			desc = "[C]ode [F]ormat Buffer",
		},
	},
}
