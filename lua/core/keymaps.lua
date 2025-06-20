local keymap = vim.keymap.set

-- Basic
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>")
keymap("n", "<leader>q", vim.diagnostic.setloclist, {
	desc = "Open diagnostic [Q]uickfix list",
})
keymap({ "n", "v" }, "D", '"_d', { noremap = true, desc = "Delete without yanking" })

-- Terminal
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", {
	desc = "Exit terminal mode",
})

-- Window Navigation
keymap("n", "<C-h>", "<C-w><C-h>", {
	desc = "Move focus to the left window",
})
keymap("n", "<C-l>", "<C-w><C-l>", {
	desc = "Move focus to the right window",
})
keymap("n", "<C-j>", "<C-w><C-j>", {
	desc = "Move focus to the lower window",
})
keymap("n", "<C-k>", "<C-w><C-k>", {
	desc = "Move focus to the upper window",
})

-- Workspace diagnostics trigger (requires workspace-diagnostics plugin)
vim.api.nvim_set_keymap("n", "<C-x>", "", {
	noremap = true,
	callback = function()
		for _, client in ipairs(vim.lsp.get_clients()) do
			require("workspace-diagnostics").populate_workspace_diagnostics(client, 0)
		end
	end,
})

vim.keymap.set("n", "<leader>cp", function()
	vim.fn.setreg("+", vim.fn.expand("%"))
	vim.notify("Copied relative path to clipboard", vim.log.levels.INFO)
end, { desc = "Copy relative path of file" })
