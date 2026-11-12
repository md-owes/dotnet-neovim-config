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