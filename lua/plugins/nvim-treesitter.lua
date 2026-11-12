return {
	-- Install and manage Treesitter parsers and queries.
	-- Syntax highlighting and folding are enabled through Neovim's native
	-- Treesitter APIs in the FileType autocmd below.
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	branch = "main",
	lazy = false,

	config = function()
		-- Parsers to keep installed. `install` is a no-op for parsers that
		-- are already installed, so this is safe to run on every startup.
		local parsers = {
			"bash",
			"c",
			"cpp",
			"cmake",
			"css",
			"c_sharp",
			"diff",
			"dockerfile",
			"go",
			"html",
			"javascript",
			"json",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"python",
			"query",
			"regex",
			"rust",
			"sql",
			"toml",
			"tsx",
			"typescript",
			"typst",
			"vim",
			"vimdoc",
			"xml",
			"yaml",
		}
		require("nvim-treesitter").install(parsers)

		-- Enable native Treesitter highlighting and folding for buffers
		-- that have an installed parser.
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("nvim-treesitter-native", { clear = true }),
			callback = function(args)
				local buf = args.buf
				if not vim.api.nvim_buf_is_valid(buf) then
					return
				end

				-- Skip special buffers (terminal, quickfix, popups, etc.).
				if vim.bo[buf].buftype ~= "" then
					return
				end

				local ft = vim.bo[buf].filetype
				if ft == "" or not vim.treesitter.language.get_lang(ft) then
					return
				end

				if pcall(vim.treesitter.start, buf) then
					vim.wo.foldmethod = "expr"
					vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
					vim.wo.foldlevel = 99
				end
			end,
		})
	end,
}