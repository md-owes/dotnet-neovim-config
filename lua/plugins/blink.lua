return {
	"saghen/blink.cmp",
	dependencies = {
		"saghen/blink.lib",
		"rafamadriz/friendly-snippets",
		{ "saghen/blink.compat", lazy = true, opts = {} },
	},
	build = function()
		require("blink.cmp").build():pwait()
	end,
	opts = {
		keymap = { preset = "default" },
		appearance = {
			nerd_font_variant = "mono",
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer", "avante_commands", "avante_mentions", "avante_files", "ecolog" },
			providers = {
				avante_commands = {
					name = "avante_commands",
					module = "blink.compat.source",
					score_offset = 90,
					opts = {},
				},
				avante_files = {
					name = "avante_files",
					module = "blink.compat.source",
					score_offset = 100,
					opts = {},
				},
				avante_mentions = {
					name = "avante_mentions",
					module = "blink.compat.source",
					score_offset = 1000,
					opts = {},
				},
				ecolog = {
					name = "ecolog",
					module = "ecolog.integrations.cmp.blink_cmp",
					score_offset = 50,
				},
			},
		},
		signature = { enabled = true },
		completion = { documentation = { auto_show = false } },
		fuzzy = { implementation = "rust" },
	},
	opts_extend = { "sources.default" },
}
