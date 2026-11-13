--[[ ---------------------------------------------------------------------
  snacks.nvim - picker, explorer, dashboard and small utilities
  Repo: folke/snacks.nvim

  WHAT IT IS
    A collection of small, high-quality Neovim utilities bundled in
    one plugin. In this config it is the main way you find and open
    things: the fuzzy picker (files, grep, buffers, LSP results),
    the file explorer, the start dashboard, and a set of quiet
    quality-of-life modules (big-file handling, indent guides,
    input prompts, scope, scrolling, statuscolumn, word
    highlighting, image preview and lazygit).

  WHY IT IS USEFUL
    - One fast picker replaces several plugins for searching files,
      text, buffers, help, keymaps and LSP symbols.
    - The explorer replaces netrw for browsing the project tree.
    - The dashboard gives a useful start screen with shortcuts.
    - Small modules (indent guides, big-file mode, quickfile) make
      everyday editing smoother without separate plugins.

  HOW IT IS CONFIGURED HERE
    - priority = 1000, lazy = false: loads at startup so the
      dashboard and picker are available immediately.
    - bigfile.enabled = true: large files open with heavy features
      disabled so they stay fast.
    - dashboard.enabled = true, with preset keys:
        F Find File (:lua Snacks.dashboard.pick('files'))
        N New File (:ene | startinsert)
        G Find Text (:lua Snacks.dashboard.pick('live_grep'))
        R Recent Files (:lua Snacks.dashboard.pick('oldfiles'))
        C Config (files picker in stdpath('config'))
        S Restore Session (session section)
        L Lazy (:Lazy)    Q Quit (:qa)
    - explorer.enabled = true, replace_netrw = true: Snacks
      explorer is the file explorer (netrw is disabled in
      lua/core/options.lua).
    - indent, input, quickfile, scope, scroll, statuscolumn,
      words, image, lazygit: all enabled with defaults.
    - notifier.enabled = false, on purpose: Noice routes vim.notify
      to nvim-notify (see lua/plugins/noice.lua), so Snacks must
      not also own notifications.
    - picker.enabled = true, with win.input.keys and win.list.keys
      mapping <CR> to the custom 'tab_unique' action, in normal and
      insert mode for the input window. Snacks' default confirm
      action edits the file in the current window, replacing the
      buffer; this config jumps to the file's existing tab if it is
      already open, otherwise opens the selection in a NEW TAB
      (added for the 'open in a new tab' request - see the comment
      in the picker table below).

  HOW TO INVOKE IT
    - Keymaps in lua/core/keymaps.lua (all normal mode):
        <leader>sf - Search Files: Snacks.picker.files()
        <leader>sg - Search Grep: Snacks.picker.grep()
        <leader>sb - Search Buffers: Snacks.picker.buffers()
        <leader>sh - Search Help: Snacks.picker.help()
        <leader>sk - Search Keymaps: Snacks.picker.keymaps()
        <leader>sr - Search Resume: Snacks.picker.resume()
        <leader>sq - Search Quickfix: Snacks.picker.qflist()
        <leader>/  - Search Lines: Snacks.picker.lines()
        <leader>e  - File Explorer: Snacks.explorer()
        <leader>gf - Git Files: Snacks.picker.git_files()
        <leader>gs - Git Status: Snacks.picker.git_status()
        <leader>gl - Git Log: Snacks.picker.git_log()
        gd / gr / gI / gy - LSP definitions, references,
          implementations, type definitions (Snacks pickers)
        <leader>ss - LSP Symbols: Snacks.picker.lsp_symbols()
    - :FindAllFiles (lua/core/autocommands.lua) - files picker
      including hidden and ignored files.
    - In any picker: type to filter, <CR> opens the selection in a
      new tab (see above); other picker keys follow Snacks defaults.

  FEATURES
    - Fuzzy picker for files, grep, buffers, help, git and LSP.
    - File explorer with netrw replacement.
    - Start dashboard with file, text, recent and config shortcuts.
    - Indent guides, scoped highlighting and word highlighting.
    - Big-file mode, quickfile loading and smooth scrolling.
    - Lazygit integration and image preview support.
    - Picker sources used by Avante, LSP keymaps and the dashboard.
---------------------------------------------------------------------]]


return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		bigfile = {
			enabled = true,
		},
		dashboard = {
			enabled = true,
			preset = {
				keys = {
					{ icon = " ", key = "F", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
					{ icon = " ", key = "N", desc = "New File", action = ":ene | startinsert" },
					{ icon = "󰈞 ", key = "G", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
					{ icon = " ", key = "R", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
					{ icon = " ", key = "C", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
					{ icon = " ", key = "S", desc = "Restore Session", section = "session" },
					{ icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy" },
					{ icon = " ", key = "Q", desc = "Quit", action = ":qa" },
				},
			},
		},
		explorer = {
			enabled = true,
			replace_netrw = true,
		},
		indent = {
			enabled = true,
		},
		input = {
			enabled = true,
		},
		picker = {
			enabled = true,
			-- Open the selected file in a new tab instead of
			-- replacing the current buffer (Snacks' default
			-- confirm action edits the file in the current window),
			-- reusing the tab if the file is already open there.
			actions = {
				tab_unique = function(picker)
					-- Mirror jump(): leaving insert mode first avoids cursor issues.
					if vim.fn.mode():sub(1, 1) == "i" then
						vim.cmd.stopinsert()
						vim.schedule(function()
							picker:action("tab_unique")
						end)
						return
					end
					local items = picker:selected({ fallback = true })
					if #items == 0 then
						return
					end
					local function item_path(item)
						local path = nil
						if item.file then
							path = Snacks.picker.util.path(item)
						end
						if (not path or path == "") and item.buf and vim.api.nvim_buf_is_valid(item.buf) then
							path = vim.api.nvim_buf_get_name(item.buf)
						end
						return path
					end
					local function normalize(path)
						return vim.uv.fs_realpath(path) or vim.fn.fnamemodify(path, ":p")
					end
					local first_path = item_path(items[1])
					-- Non-file items (help, keymaps, commands) and directories
					-- have no tab to reuse: keep the built-in behaviour.
					if not first_path or first_path == "" then
						picker:action("tab")
						return
					end
					if vim.fn.isdirectory(first_path) == 1 then
						picker:action("confirm")
						return
					end
					picker:close()
					for _, item in ipairs(items) do
						local path = item_path(item)
						if path and path ~= "" and vim.fn.isdirectory(path) == 0 then
							local target = normalize(path)
							local found_win, found_tab = nil, nil
							local bufnr = item.buf
							if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
								bufnr = vim.fn.bufnr(path)
							end
							if bufnr and bufnr > 0 then
								for _, w in ipairs(vim.fn.win_findbuf(bufnr)) do
									if vim.api.nvim_win_get_config(w).relative == "" then
										found_win = w
										found_tab = vim.api.nvim_win_get_tabpage(w)
										break
									end
								end
							end
							if not found_win then
								for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
									for _, w in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
										if vim.api.nvim_win_get_config(w).relative == "" then
											local name = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
											if name ~= "" and normalize(name) == target then
												found_win = w
												found_tab = tab
												break
											end
										end
									end
									if found_win then
										break
									end
								end
							end
							if found_win and found_tab then
								vim.api.nvim_set_current_tabpage(assert(found_tab))
								vim.api.nvim_set_current_win(found_win)
								if item.pos and item.pos[1] and item.pos[1] > 0 then
									pcall(vim.api.nvim_win_set_cursor, found_win, { item.pos[1], item.pos[2] or 0 })
									vim.cmd("norm! zz")
								end
							else
								local cur_buf = vim.api.nvim_get_current_buf()
								local cur_empty = vim.bo[cur_buf].buftype == "" and vim.bo[cur_buf].filetype == "" and vim.api.nvim_buf_line_count(cur_buf) == 1 and vim.api.nvim_buf_get_lines(cur_buf, 0, -1, false)[1] == "" and vim.api.nvim_buf_get_name(cur_buf) == ""
								local cur_tab_wins = #vim.tbl_filter(function(w)
									return vim.api.nvim_win_get_config(w).relative == ""
								end, vim.api.nvim_tabpage_list_wins(vim.api.nvim_get_current_tabpage()))
								if cur_empty and cur_tab_wins == 1 then
									vim.cmd("edit " .. vim.fn.fnameescape(path))
								else
									vim.cmd("tabedit " .. vim.fn.fnameescape(path))
								end
								if item.pos and item.pos[1] and item.pos[1] > 0 then
									pcall(vim.api.nvim_win_set_cursor, 0, { item.pos[1], item.pos[2] or 0 })
									vim.cmd("norm! zz")
								end
							end
						end
					end
				end,
			},
			win = {
				input = {
					keys = {
						["<CR>"] = { "tab_unique", mode = { "n", "i" } },
					},
				},
				list = {
					keys = {
						["<CR>"] = "tab_unique",
					},
				},
			},
		},
		notifier = {
			-- Disabled: Noice routes vim.notify to nvim-notify.
			enabled = false,
		},
		quickfile = {
			enabled = true,
		},
		scope = {
			enabled = true,
		},
		scroll = {
			enabled = true,
		},
		statuscolumn = {
			enabled = true,
		},
		words = {
			enabled = true,
		},
		image = {
			enabled = true,
		},
		lazygit = {
			enabled = true,
		},
	},
}
