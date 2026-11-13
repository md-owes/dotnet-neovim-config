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


-- Helpers for the `tab_unique` picker action, defined once at module
-- level (not inside the lazy spec) so the action itself stays small,
-- each helper has one job, and the logic is easy to test and change.
-- Performance notes:
-- * Open windows are scanned once per invocation and indexed by
--   normalised path, instead of rescanning all tabs/windows for
--   every selected item (was O(items * tabs * windows)).
-- * Path normalisation (fs_realpath, a syscall) is memoised per
--   invocation, so each distinct path is resolved only once.
-- * The fast path uses win_findbuf(bufnr) instead of a full scan.

local function is_normal_window(win)
	return vim.api.nvim_win_get_config(win).relative == ""
end

local function normalize_path(path, cache)
	local cached = cache[path]
	if cached then
		return cached
	end
	local normalized = vim.uv.fs_realpath(path) or vim.fn.fnamemodify(path, ":p")
	cache[path] = normalized
	return normalized
end

local function picker_item_path(item)
	if item.file then
		local path = Snacks.picker.util.path(item)
		if path and path ~= "" then
			return path
		end
	end
	if item.buf and vim.api.nvim_buf_is_valid(item.buf) then
		return vim.api.nvim_buf_get_name(item.buf)
	end
	return nil
end

-- Single O(tabs * windows) pass: normalised path -> { win, tab }.
-- First window wins, so repeated paths keep a stable target.
local function build_open_index(normalize)
	local index = {}
	for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
			if is_normal_window(win) then
				local name = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
				if name ~= "" then
					local key = normalize(name)
					if index[key] == nil then
						index[key] = { win = win, tab = tab }
					end
				end
			end
		end
	end
	return index
end

-- Fast path first: windows showing the buffer (no full scan). Falls
-- back to the prebuilt index, which also covers the same file opened
-- under a different spelling / symlink of its path.
local function find_open_location(item, target, index)
	local bufnr = item.buf
	if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
		bufnr = vim.fn.bufnr(target)
	end
	if bufnr and bufnr > 0 then
		for _, win in ipairs(vim.fn.win_findbuf(bufnr)) do
			if is_normal_window(win) then
				return win, vim.api.nvim_win_get_tabpage(win)
			end
		end
	end
	local found = index[target]
	if found then
		return found.win, found.tab
	end
	return nil, nil
end

local function goto_location(win, tab, pos)
	vim.api.nvim_set_current_tabpage(assert(tab))
	vim.api.nvim_set_current_win(assert(win))
	if pos and pos[1] and pos[1] > 0 then
		pcall(vim.api.nvim_win_set_cursor, win, { pos[1], pos[2] or 0 })
		vim.cmd("norm! zz")
	end
end

local function is_reusable_empty_buffer(bufnr)
	if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype ~= "" then
		return false
	end
	if vim.api.nvim_buf_get_name(bufnr) ~= "" then
		return false
	end
	if vim.api.nvim_buf_line_count(bufnr) ~= 1 then
		return false
	end
	return vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)[1] == ""
end

local function open_new_tab(path, pos, reuse_current)
	if reuse_current then
		vim.cmd("edit " .. vim.fn.fnameescape(path))
	else
		vim.cmd("tabedit " .. vim.fn.fnameescape(path))
	end
	if pos and pos[1] and pos[1] > 0 then
		pcall(vim.api.nvim_win_set_cursor, 0, { pos[1], pos[2] or 0 })
		vim.cmd("norm! zz")
	end
end

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
					local first_path = picker_item_path(items[1])
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
					-- One memoised normaliser and one index of open windows
					-- for all selected items, instead of a full scan per item.
					local path_cache = {}
					local function normalize(path)
						return normalize_path(path, path_cache)
					end
					local open_index = build_open_index(normalize)
					for _, item in ipairs(items) do
						local path = picker_item_path(item)
						if path and path ~= "" and vim.fn.isdirectory(path) == 0 then
							local target = normalize(path)
							local found_win, found_tab = find_open_location(item, target, open_index)
							if found_win and found_tab then
								goto_location(found_win, found_tab, item.pos)
							else
								local cur_buf = vim.api.nvim_get_current_buf()
								local cur_tab_wins = #vim.tbl_filter(is_normal_window, vim.api.nvim_tabpage_list_wins(vim.api.nvim_get_current_tabpage()))
								open_new_tab(path, item.pos, is_reusable_empty_buffer(cur_buf) and cur_tab_wins == 1)
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
