return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		local tokyonight = require("tokyonight")

		tokyonight.setup({
			style = "night", -- "storm", "moon", "night", or "day"
			transparent = false, -- Set to true if you want transparency
			terminal_colors = true,
			styles = {
				functions = {}, -- Disable italic for functions
			},
			on_colors = function(colors)
				colors.hint = colors.orange
				colors.error = "#ff0000"
			end,
			on_highlights = function(highlights, colors)
				highlights.TSFunction = { italic = true, fg = colors.blue }
			end,
		})

		vim.cmd.colorscheme("tokyonight-night")
		vim.opt.background = "dark"
	end,
}
