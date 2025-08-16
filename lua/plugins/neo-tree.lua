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

					-- Avante integration: Add file to Avante context
					["oa"] = function(state)
						local node = state.tree:get_node()
						if not node or node.type == "directory" then
							return
						end

						local filepath = node:get_id()
						local relative_path = vim.fn.fnamemodify(filepath, ":.")

						-- Check if Avante is available
						local avante_ok, avante = pcall(require, "avante.api")
						if not avante_ok then
							vim.notify("Avante not available", vim.log.levels.WARN)
							return
						end

						-- Get current Avante instance or create new ask
						local sidebar = require("avante").get()
						local open = sidebar and sidebar:is_open()

						if not open then
							avante.ask()
							sidebar = require("avante").get()
						end

						if sidebar and sidebar.file_selector then
							sidebar.file_selector:add_selected_file(relative_path)
							vim.notify("Added " .. relative_path .. " to Avante context", vim.log.levels.INFO)
						end
					end,

					-- Avante integration: Add multiple selected files
					["oA"] = function(state)
						local node = state.tree:get_node()
						if not node then
							return
						end

						-- If it's a directory, add all files recursively
						local function add_files_recursive(dir_node)
							if dir_node.type == "file" then
								local filepath = dir_node:get_id()
								local relative_path = vim.fn.fnamemodify(filepath, ":.")

								local avante_ok, avante = pcall(require, "avante.api")
								if avante_ok then
									local sidebar = require("avante").get()
									if sidebar and sidebar.file_selector then
										sidebar.file_selector:add_selected_file(relative_path)
									end
								end
							elseif dir_node.type == "directory" and dir_node:is_expanded() then
								for _, child in ipairs(dir_node:get_children()) do
									add_files_recursive(child)
								end
							end
						end

						-- Check if Avante is available
						local avante_ok, avante = pcall(require, "avante.api")
						if not avante_ok then
							vim.notify("Avante not available", vim.log.levels.WARN)
							return
						end

						-- Get current Avante instance or create new ask
						local sidebar = require("avante").get()
						local open = sidebar and sidebar:is_open()

						if not open then
							avante.ask()
							sidebar = require("avante").get()
						end

						add_files_recursive(node)
						vim.notify("Added files from " .. node.name .. " to Avante context", vim.log.levels.INFO)
					end,
				},
			},
		},
	},
	keys = {
		{
			"<leader>ne",
			"<cmd>Neotree filesystem reveal float<CR>",
			desc = "Neo-tree reveal (float)",
		},
		{
			"<leader>nb",
			"<cmd>Neotree buffers toggle<CR>",
			desc = "Neo-tree Buffers",
		},
		{
			"<leader>ng",
			"<cmd>Neotree git_status toggle<CR>",
			desc = "Neo-tree Git",
		},
		-- Avante integration keys
		{
			"<leader>na",
			function()
				vim.cmd("Neotree filesystem reveal float")
				vim.notify("Use 'oa' to add files to Avante context, 'oA' for directories", vim.log.levels.INFO)
			end,
			desc = "Neo-tree with Avante help",
		},
	},
}
