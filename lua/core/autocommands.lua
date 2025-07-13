vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", {
		clear = true,
	}),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Require the shared state module at the top
local state = require("core.state")

-- Autocommand to track the last used tab
vim.api.nvim_create_autocmd("TabLeave", {
	pattern = "*",
	desc = "Track last used tab",
	group = vim.api.nvim_create_augroup("TabTracking", { clear = true }), -- Use a dedicated group
	callback = function()
		-- vim.t.tabpage is the previous tab page number on TabLeave
		if vim.t.tabpage and vim.t.tabpage ~= vim.api.nvim_get_current_tabpage() then
			state.last_tab = vim.t.tabpage -- Write to the shared state
		end
	end,
})
