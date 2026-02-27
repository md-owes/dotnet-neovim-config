return {
	"gutsavgupta/nvim-gemini-companion",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = "VeryLazy",
	config = function()
		require("gemini").setup()
	end,
	keys = {
		{ "<leader>zg", "<cmd>GeminiToggle<cr>", desc = "Toggle Gemini sidebar" },
		{ "<leader>zc", "<cmd>GeminiSwitchToCli<cr>", desc = "Spawn or switch to AI session" },
		{ "<leader>zs", "<cmd>GeminiSend<cr>", mode = { "x" }, desc = "Send selection to Gemini" },
	},
}
