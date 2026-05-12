return {
	url = "https://codeberg.org/andyg/leap.nvim",
	keys = {
		{
			"<leader>i",
			"<Plug>(leap-forward)",
			mode = { "n", "x", "o" },
			desc = "Leap forward",
		},
		{
			"<leader>I",
			"<Plug>(leap-backward)",
			mode = { "n", "x", "o" },
			desc = "Leap backward",
		},
		{
			"<leader>G",
			"<Plug>(leap-from-window)",
			mode = { "n", "x", "o" },
			desc = "Leap from window",
		},
	},
}
