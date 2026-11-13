--[[ ---------------------------------------------------------------------
  nvim-treesitter - incremental parser manager, highlighting and folding
  Repo: nvim-treesitter/nvim-treesitter

  WHAT IT IS
    Installs and manages Treesitter parsers, the fast incremental
    parsers that understand code structure instead of only matching
    text with regular expressions. This config uses the modern
    'main' branch and Neovim's native Treesitter APIs: highlighting
    and folding are enabled through vim.treesitter.start() in a
    FileType autocmd, rather than through the old setup() table.

  WHY IT IS USEFUL
    - Accurate syntax highlighting: keywords, types, functions,
      strings and comments are coloured by their real role in the
      syntax tree, not by fragile regex patterns.
    - Structure-aware folding: folds follow functions, blocks and
      other syntax nodes instead of indentation alone.
    - Other plugins build on the same parsers: textobjects, queries
      and highlighting in mini.ai, render-markdown and elsewhere
      rely on a parser being installed for the filetype.
    - Parsers are installed once and kept up to date with :TSUpdate.

  HOW IT IS CONFIGURED HERE
    - branch = 'main', lazy = false, build = ':TSUpdate'.
    - config() installs 29 parsers on every startup; install is a
      no-op for parsers already installed, so this is safe:
        bash, c, cpp, cmake, css, c_sharp, diff, dockerfile, go,
        html, javascript, json, lua, luadoc, markdown,
        markdown_inline, python, query, regex, rust, sql, toml,
        tsx, typescript, typst, vim, vimdoc, xml, yaml
    - FileType autocmd, group 'nvim-treesitter-native':
        skips special buffers (buftype ~= '') and buffers with no
        filetype or no language for that filetype, then calls
        pcall(vim.treesitter.start, buf) and, on success, sets
        foldmethod = 'expr', foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        and foldlevel = 99 (all folds start open).
    - No classic setup() options are used: no textobjects or
      incremental-selection module is configured here.

  HOW TO INVOKE IT
    - Automatic: open a file whose language has an installed parser
      and highlighting plus folding start by themselves.
    - :TSUpdate - update all installed parsers.
    - :TSInstall <language> / :TSUninstall <language> - manage one parser.
    - :checkhealth nvim-treesitter - parser and query status.
    - Folding keys work as usual once enabled: za toggles a fold,
      zM closes all folds, zR opens all folds.

  FEATURES
    - Per-language parser installation and updates.
    - Native Treesitter syntax highlighting per buffer.
    - Syntax-aware folding with all folds open by default.
    - Parser queries (query, luadoc, vimdoc parsers included) for
      other plugins and for :InspectTree / :Inspect.
---------------------------------------------------------------------]]


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
