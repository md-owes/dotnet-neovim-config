return {
	"MagicDuck/grug-far.nvim",
	-- Note (lazy loading): grug-far.lua defers all it's requires so it's lazy by default
	-- additional lazy config to defer loading is not really needed...
	opts = {
		-- Enable history, allowing you to recall previous searches.
		-- Your existing setting for this is correct!
		history = {
			enabled = true,
		},

		-- Keep the useful pre-fill options
		prefill_word_under_cursor = true,
		prefill_last_search = true,
	},
	keys = {
		-- Shortcut for standard project-wide Find & Replace
		{
			"<leader>fr",
			"<cmd>GrugFar<cr>",
			mode = "n",
			desc = "Find & Replace in Project",
		},
		{
			"<leader>fr",
			"<cmd>GrugFarVisual<cr>",
			mode = "v",
			desc = "Find & Replace Visual Selection",
		},
	},
}
