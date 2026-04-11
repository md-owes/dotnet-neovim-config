return {
	-- Highlight, edit, and navigate code
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	branch = "main", -- Uses the latest rewritten branch
	lazy = false, -- Treesitter should start immediately for optimal performance
	config = function()
		local ts = require("nvim-treesitter")
		local parser_config = require("nvim-treesitter.parsers")

		-- 1. Install desired parsers
		-- Programmatic replacement for the old `ensure_installed` table
		local parsers = {
			"bash",
			"c",
			"diff",
			"html",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"query",
			"vim",
			"vimdoc",
			"astro",
			"css",
			"c_sharp",
			"javascript",
			"typescript",
			"tsx",
			"regex",
			"dockerfile",
			"json",
			"yaml",
			"xml",
			"toml",
			"rust",
			"go",
			"typst",
			"python",
		}

		-- Non-blocking installation check (only installs missing parsers)
		vim.schedule(function()
			local install = require("nvim-treesitter.install")
			local installed = ts.get_installed()
			local installed_map = {}
			for _, p in ipairs(installed) do
				installed_map[p] = true
			end

			for _, parser in ipairs(parsers) do
				if not installed_map[parser] then
					install.install(parser)
				end
			end
		end)

		-- 2. Enable syntax highlighting and folding
		-- Using Neovim's native Treesitter APIs
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("nvim-treesitter-setup", { clear = true }),
			callback = function(args)
				local buf = args.buf
				if not vim.api.nvim_buf_is_valid(buf) then
					return
				end

				-- Skip special buffers (like snacks_notif, prompt, etc.)
				if vim.bo[buf].buftype ~= "" then
					return
				end

				-- Ensure there is a parser for the current filetype
				local ft = vim.bo[buf].filetype
				if ft == "" or not vim.treesitter.language.get_lang(ft) then
					return
				end

				-- Start highlighting (wrapped in pcall to be safe)
				local ok = pcall(vim.treesitter.start, buf)
				if not ok then
					return
				end

				-- Enable Treesitter-based folding
				vim.wo.foldmethod = "expr"
				vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
				vim.wo.foldlevel = 99 -- Open all folds by default
			end,
		})
	end,
}
