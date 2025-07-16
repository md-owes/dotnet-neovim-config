return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
	opts = {
		sources = { "filesystem", "buffers", "git_status", "diagnostics" },
		use_libuv_file_watcher = true,
		diagnostics = {
			enable = true,
			show_on_dirs = true,
			show_on_open_dirs = false,
		},
		default_component_configs = {
			diagnostics = {
				symbols = {
					hint = "",
					info = "",
					warn = "",
					error = "",
				},
			},
		},
		filesystem = {
			window = {
				mappings = {
					["<CR>"] = function(state)
						local node = state.tree:get_node()
						local path = node.path
						if not path then
							return
						end

						-- Check if buffer is already open in a tab
						for _, tabnr in ipairs(vim.api.nvim_list_tabpages()) do
							for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabnr)) do
								local buf = vim.api.nvim_win_get_buf(win)
								local bufname = vim.api.nvim_buf_get_name(buf)
								if bufname == path then
									vim.cmd("tabnext " .. vim.api.nvim_tabpage_get_number(tabnr))
									return
								end
							end
						end

						-- Otherwise open in a new tab
						vim.cmd("tabnew " .. vim.fn.fnameescape(path))
					end,
				},
			},
		},
	},
	keys = {
		{
			"<leader>e",
			"<cmd>Neotree filesystem reveal float<CR>",
			desc = "Neo-tree reveal (float)",
		},
		{
			"<leader>b",
			"<cmd>Neotree buffers toggle<CR>",
			desc = "Neo-tree Buffers",
		},
		{
			"<leader>g",
			"<cmd>Neotree git_status toggle<CR>",
			desc = "Neo-tree Git",
		},
	},
}
