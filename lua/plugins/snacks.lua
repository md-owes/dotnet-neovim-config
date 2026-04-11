return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		bigfile = {
			enabled = true,
		},
		dashboard = {
			enabled = true,
			preset = {
				keys = {
					{ icon = " ", key = "F", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
					{ icon = " ", key = "N", desc = "New File", action = ":ene | startinsert" },
					{ icon = "󰈞 ", key = "G", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
					{ icon = " ", key = "R", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
					{ icon = " ", key = "C", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
					{ icon = " ", key = "S", desc = "Restore Session", section = "session" },
					{ icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy" },
					{ icon = " ", key = "Q", desc = "Quit", action = ":qa" },
				},
			},
		},
		explorer = {
			enabled = true,
			replace_netrw = true,
		},
		indent = {
			enabled = true,
		},
		input = {
			enabled = true,
		},
		picker = {
			enabled = true,
		},
		notifier = {
			enabled = true,
		},
		quickfile = {
			enabled = true,
		},
		scope = {
			enabled = true,
		},
		scroll = {
			enabled = true,
		},
		statuscolumn = {
			enabled = true,
		},
		words = {
			enabled = true,
		},
		image = {
			enabled = true,
		},
		lazygit = {
			enabled = true,
		},
	},
}
