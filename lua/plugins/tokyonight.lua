--[[ ---------------------------------------------------------------------
  tokyonight.nvim - colourscheme (the look of the whole editor)
  Repo: folke/tokyonight.nvim

  WHAT IT IS
    The colourscheme for this config: it defines the colours of
    syntax highlighting, the UI, diagnostics, diffs, the statusline
    and every plugin that follows the active colourscheme. Without
    it Neovim would fall back to its plain default colours; with it
    the editor has the dark Tokyo Night palette everywhere, from
    code to the Snacks picker, the dashboard and Trouble.

  WHY IT IS USEFUL
    - One consistent dark palette across code, UI and plugins,
      instead of each plugin bringing its own colours.
    - Treesitter groups, LSP diagnostics and diff highlighting are
      all tuned for this theme, so errors, hints and changes are
      easy to tell apart at a glance.
    - The small overrides below make function names italic blue
      and give hint and error diagnostics distinct colours.

  HOW IT IS CONFIGURED HERE
    - lazy = false, priority = 1000: loads at startup before other
      plugins, so nothing flashes the default colours first.
    - config() calls tokyonight.setup() and then applies it with
      vim.cmd.colorscheme('tokyonight').
    - transparent = false: the background stays solid, not the
      terminal background showing through.
    - terminal_colors = true: the built-in terminal uses the same
      Tokyo Night palette.
    - styles.functions = {}: the base Function group is kept plain;
      the italic styling for functions comes from the override
      below, which targets the Treesitter @function group instead.
    - on_colors: colors.hint = colors.orange (hints use orange),
      colors.error = '#ff0000' (errors use pure red).
    - on_highlights: highlights['@function'] = { italic = true,
      fg = colors.blue } - function names are italic blue.
    - The commented style line shows the available variants:
      'night', 'storm', 'moon' or 'day'; the default (night) is
      used here. The commented vim.opt.background = 'dark' line
      is likewise left at its default.

  HOW TO INVOKE IT
    - Automatic: it is applied on every startup; there is nothing
      to open or toggle.
    - :colorscheme tokyonight - re-apply it manually if another
      colourscheme was set in the session.
    - :colorscheme tokyonight-storm / -moon / -day - try the other
      variants (note: switching does not persist; edit the setup
      call above to make a variant permanent).

  FEATURES
    - Four style variants (night, storm, moon, day) in one plugin.
    - Full Treesitter, LSP, diagnostic and diff highlighting.
    - Terminal colours and plugin integrations (lualine, Snacks,
      Trouble, gitsigns and others follow the theme).
    - on_colors / on_highlights hooks for small, targeted tweaks
      without forking the theme.
---------------------------------------------------------------------]]


return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		local tokyonight = require("tokyonight")

		tokyonight.setup({
			-- style = "night", -- "storm", "moon", "night", or "day"
			transparent = false, -- Set to true if you want transparency
			terminal_colors = true,
			styles = {
				functions = {}, -- Keep the base Function group plain; the override below adds italics for treesitter highlights
			},
			on_colors = function(colors)
				colors.hint = colors.orange
				colors.error = "#ff0000"
			end,
			on_highlights = function(highlights, colors)
				highlights["@function"] = { italic = true, fg = colors.blue }
			end,
		})

		vim.cmd.colorscheme("tokyonight")
		-- vim.opt.background = "dark"
	end,
}
