local keymap = vim.keymap.set

-- Basic
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>")
keymap("n", "<leader>q", vim.diagnostic.setloclist, {
	desc = "Open diagnostic [L]ocation list",
})
keymap({ "n", "v" }, "D", '"_d', { noremap = true, desc = "Delete without yanking" })

-- Terminal
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", {
	desc = "Exit terminal mode",
})

-- Window Navigation (Normal & Terminal modes)
local function nav(key, dir)
	keymap({ "n", "t" }, key, function()
		vim.cmd.wincmd(dir)
	end, { desc = "Move focus to the " .. dir .. " window" })
end

nav("<C-h>", "h")
nav("<C-l>", "l")
nav("<C-j>", "j")
nav("<C-k>", "k")

vim.keymap.set("n", "<leader>cp", function()
	vim.fn.setreg("+", vim.fn.expand("%"))
	vim.notify("Copied relative path to clipboard", vim.log.levels.INFO)
end, { desc = "Copy relative path of file" })

-- [[ Snacks Navigation ]]
-- Search
keymap("n", "<leader>sf", function() Snacks.picker.files() end, { desc = "Search Files" })
keymap("n", "<leader>sg", function() Snacks.picker.grep() end, { desc = "Search Grep" })
keymap("n", "<leader>sb", function() Snacks.picker.buffers() end, { desc = "Search Buffers" })
keymap("n", "<leader>sh", function() Snacks.picker.help() end, { desc = "Search Help" })
keymap("n", "<leader>sk", function() Snacks.picker.keymaps() end, { desc = "Search Keymaps" })
keymap("n", "<leader>sr", function() Snacks.picker.resume() end, { desc = "Search Resume" })
keymap("n", "<leader>sq", function() Snacks.picker.qflist() end, { desc = "Search Quickfix" })
keymap("n", "<leader>/", function() Snacks.picker.lines() end, { desc = "Search Lines" })

-- Explorer
keymap("n", "<leader>e", function() Snacks.explorer() end, { desc = "File Explorer" })

-- Git
keymap("n", "<leader>gf", function() Snacks.picker.git_files() end, { desc = "Git Files" })
keymap("n", "<leader>gs", function() Snacks.picker.git_status() end, { desc = "Git Status" })
keymap("n", "<leader>gl", function() Snacks.picker.git_log() end, { desc = "Git Log" })

-- LSP
keymap("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Goto Definition" })
keymap("n", "gr", function() Snacks.picker.lsp_references() end, { desc = "Goto References" })
keymap("n", "gI", function() Snacks.picker.lsp_implementations() end, { desc = "Goto Implementation" })
keymap("n", "gy", function() Snacks.picker.lsp_type_definitions() end, { desc = "Goto Type Definition" })
keymap("n", "<leader>ss", function() Snacks.picker.lsp_symbols() end, { desc = "LSP Symbols" })
