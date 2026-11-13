--[[ ---------------------------------------------------------------------
  mini.nvim - collection of small, independent Neovim modules
  Repo: echasnovski/mini.nvim

  WHAT IT IS
    A single plugin that bundles 40+ small modules, each doing one
    job well. This config does not use all of them - it enables only
    the modules below in one config() function. mini.nvim is also a
    dependency for other plugins here (icons for lualine / render-
    markdown, the devicons mock used across the UI).

  WHY IT IS USEFUL
    - One plugin instead of five separate ones for textobjects,
      surround, sessions, icons and bracket motions.
    - Each module is independent: enabling or removing one does not
      affect the others, and unused modules cost nothing.
    - mini.icons replaces nvim-web-devicons for the whole config,
      so filetype icons stay consistent in lualine, Snacks and
      render-markdown without a second icon plugin.

  HOW IT IS CONFIGURED HERE
    - mini.ai: setup({ n_lines = 500 }) - better around/inside
      textobjects, searching up to 500 lines for the target.
    - mini.surround: custom 'gz' prefix instead of the default 'sa':
        gza - add surrounding        gzd - delete surrounding
        gzf - find surrounding       gzF - find surrounding (left)
        gzh - highlight surrounding  gzr - replace surrounding
        gzn - update n_lines for the surrounding search
      The 'gz' group is documented in which-key (see which-key.lua).
    - mini.statusline: present but commented out on purpose - the
      statusline in this config is lualine.nvim (see lualine.lua);
      the commented example shows forcing 'LINE:COLUMN' format.
    - mini.sessions: setup({ autoread = true, autowrite = true }) -
      the latest session is read on startup and written on exit.
    - mini.icons: setup() plus MiniIcons.mock_nvim_web_devicons(),
      so plugins that only know the devicons API (lualine and
      others) keep working without nvim-web-devicons installed.
    - mini.bracketed: setup() with defaults - adds ] / [ motions
      for buffers, comments, conflicts, diagnostics, files, indents,
      jumps, locations, oldfiles, quickfix, treesitter, undo, windows
      and yanks (for example ]b / [b for buffers, ]d / [d style jumps
      where they do not clash with the LSP diagnostic maps).

  HOW TO INVOKE IT
    - Textobjects (mini.ai): va) visually select around parens,
      yinq yank inside next quote, ci' change inside quote - use
      a / i with ), ], }, quotes, tags, functions, arguments, etc.
    - Surround (mini.surround): gzaiw) surround inner word with ),
      gzd' delete surrounding quotes, gzr)' replace ) with '.
    - Sessions (mini.sessions): automatic on start / exit; also
      :lua MiniSessions.write() / MiniSessions.read() on demand,
      session files live under stdpath('data')/session.
    - Bracketed: press the ]x / [x pair for the target listed above.
    - Icons: nothing to invoke, they are used by other plugins.

  FEATURES
    - Extended, repeatable around/inside textobjects with next/last.
    - Add, delete, find, highlight and replace surroundings.
    - Automatic session save and restore per working directory.
    - Filetype / extension / filename icons with a devicons shim.
    - A full family of consistent ] / [ navigation motions.
---------------------------------------------------------------------]]


return { -- Collection of various small independent plugins/modules
	"echasnovski/mini.nvim",
	config = function()
		-- Better Around/Inside textobjects
		--
		-- Examples:
		--  - va)  - [V]isually select [A]round [)]paren
		--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
		--  - ci'  - [C]hange [I]nside [']quote
		require("mini.ai").setup({
			n_lines = 500,
		})

		-- Add/delete/replace surroundings (brackets, quotes, etc.)
		--
		-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
		-- - sd'   - [S]urround [D]elete [']quotes
		-- - sr)'  - [S]urround [R]eplace [)] [']
		require("mini.surround").setup({
			mappings = {
				add = "gza",
				delete = "gzd",
				find = "gzf",
				find_left = "gzF",
				highlight = "gzh",
				replace = "gzr",
				update_n_lines = "gzn",
			},
		})

		-- Simple and easy statusline.
		--  You could remove this setup call if you don't like it,
		--  and try some other statusline plugin
		-- Commented the below status line in favor of lualine
		-- local statusline = require 'mini.statusline'
		-- -- set use_icons to true if you have a Nerd Font
		-- statusline.setup {
		--     use_icons = vim.g.have_nerd_font
		-- }

		-- -- You can configure sections in the statusline by overriding their
		-- -- default behavior. For example, here we set the section for
		-- -- cursor location to LINE:COLUMN
		---- ---@diagnostic disable-next-line: duplicate-set-field
		-- statusline.section_location = function()
		--     return '%2l:%-2v'
		-- end

		require("mini.sessions").setup({
			autoread = true,
			autowrite = true,
		})

		require("mini.icons").setup()
		-- Mock nvim-web-devicons so lualine and other plugins that only
		-- know the devicons API keep working without the plugin installed.
		MiniIcons.mock_nvim_web_devicons()
		require("mini.bracketed").setup()

		-- ... and there is more!
		--  Check out: https://github.com/echasnovski/mini.nvim
	end,
}
