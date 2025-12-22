return {
	"ph1losof/ecolog.nvim",
	-- Optional: you can add some keybindings
	-- (I personally use lspsaga so check out lspsaga integration or lsp integration for a smoother experience without separate keybindings)
	keys = {
		{ "<leader>eg", "<cmd>EcologGoto<cr>", desc = "Go to env file" },
		{ "<leader>ep", "<cmd>EcologPeek<cr>", desc = "Ecolog peek variable" },
		{ "<leader>es", "<cmd>EcologSelect<cr>", desc = "Switch env file" },
	},
	-- Lazy loading is done internally
	lazy = false,
	opts = {
		integrations = {
			-- WARNING: for both cmp integrations see readme section below
			nvim_cmp = true, -- If you dont plan to use nvim_cmp set to false, enabled by default
			-- If you are planning to use blink cmp uncomment this line
			-- blink_cmp = true,
		},
		-- true by default, enables built-in types (database_url, url, etc.)
		types = true,
		path = vim.fn.getcwd(), -- Path to search for .env files
		preferred_environment = "development", -- Optional: prioritize specific env files
		-- Controls how environment variables are extracted from code and how cmp works
		provider_patterns = true, -- true by default, when false will not check provider patterns
	},
}
