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

-- -- Require the shared state module at the top
-- local state = require("core.state")
-- -- ... your other existing keymaps ...
--
-- -- Function to jump to the last used tab by reading from the shared state
-- local function jump_to_last_tab()
-- 	if state.last_tab and tonumber(state.last_tab) then
-- 		vim.cmd.tabnext(state.last_tab) -- Read from the shared state
-- 	end
-- end
--
-- -- Keymap to switch to the last active tab
-- keymap("n", "gla", jump_to_last_tab, { desc = "Switch to Last Tab", noremap = true, silent = true })
--
do
	-- Use a closure to keep the state private to this feature
	local last_tab = 1
	vim.notify("[Debug] 'Jump to last tab' module loaded.", vim.log.levels.INFO)

	-- Create a dedicated autocommand group that clears itself on reload
	local tab_augroup = vim.api.nvim_create_augroup("MdoweTabTracking", { clear = true })

	-- Create the autocommand to track the last tab page number
	vim.api.nvim_create_autocmd("TabLeave", {
		group = tab_augroup,
		pattern = "*",
		desc = "Track the last used tab page",
		callback = function()
			-- vim.t.tabpage is a special var holding the number of the tab we just left
			if vim.t.tabpage and vim.t.tabpage ~= vim.api.nvim_get_current_tabpage() then
				last_tab = vim.t.tabpage
				vim.notify("TabLeave Fired! Last tab is now: " .. tostring(last_tab), vim.log.levels.INFO)
			end
		end,
	})

	-- Define the function that will perform the jump
	local function jump_to_last_tab()
		vim.notify("'gla' pressed! Trying to jump to tab: " .. tostring(last_tab), vim.log.levels.INFO)
		if last_tab and tonumber(last_tab) then
			vim.cmd.tabnext(last_tab)
		else
			vim.notify("Could not jump: last_tab value is invalid.", vim.log.levels.WARN)
		end
	end

	-- Finally, create the keymap that calls our jump function
	vim.keymap.set("n", "gla", jump_to_last_tab, { desc = "Switch to Last Tab", noremap = true, silent = true })
end
