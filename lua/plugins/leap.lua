return {
	"ggandor/leap.nvim",
	keys = {
		{
			"<leader>i",
			"<Plug>(leap-forward-to)",
			mode = { "n", "x", "o" },
			desc = "Leap forward",
		},
		{
			"<leader>I",
			"<Plug>(leap-backward-to)",
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
