vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", {
		clear = true,
	}),
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_user_command("TelescopeFindAll", function()
	require("telescope.builtin").find_files({ hidden = true, no_ignore = true })
end, { desc = "Telescope: Find all files including hidden and ignored" })
