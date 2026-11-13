--[[ ---------------------------------------------------------------------
  lualine.nvim - statusline and tabline
  Repo: nvim-lualine/lualine.nvim

  WHAT IT IS
    The statusline at the bottom of every window and the tabline at
    the top. It shows the mode, Git branch and diff, filename, the
    current LSP document-symbol breadcrumb (via trouble.nvim),
    diagnostics, encoding / fileformat / filetype, cursor progress
    and location, and renders the open tabs in the tabline.

  WHY IT IS USEFUL
    - Mode, branch, dirty diff and diagnostics are always visible,
      without running a command or opening another plugin.
    - The Trouble symbols component shows where you are inside a file
      (class / function breadcrumb) in the statusline itself.
    - The tabline matters in this config: files are set to open in
      new tabs (see lua/plugins/snacks.lua), and lualine renders those
      tabs by filename with active-tab highlighting.
    - Inactive windows keep a minimal line (filename + location), so
      the focused window is obvious at a glance.

  HOW IT IS CONFIGURED HERE
    - opts is a function that builds the options table, inserts the
      Trouble component, and returns it.
    - options: icons_enabled = vim.g.have_nerd_font, theme = 'auto',
      powerline-style component and section separators, globalstatus
      = false (per-window statuslines), refresh = 1000 ms for
      statusline, tabline and winbar, disabled_filetypes empty.
    - Active sections:
        a: mode
        b: branch, diff
        c: Trouble symbols component (inserted first), then filename
           with path = 1 (relative path)
        x: diagnostics, encoding, fileformat, filetype
        y: progress    z: location
    - Inactive sections: only filename (path = 1) in c and location
      in x; everything else is empty.
    - Tabline: section c holds the 'tabs' component with mode = 4,
      max_length = full editor width, use_mode_colors = true,
      active tab coloured lualine_a_normal and inactive tabs
      lualine_c_inactive; labels are formatted to just the file's
      tail name, or '[No Name]' for unnamed tabs.
    - winbar and inactive_winbar are empty (disabled).
    - extensions: nvim-tree, toggleterm, lazy, trouble.
    - Trouble component: trouble.statusline with mode =
      'lsp_document_symbols', groups = {}, title = false, filter
      range = true, format '{kind_icon}{symbol.name:Normal}',
      hl_group 'lualine_c_normal', shown only when it has symbols.
    - Depends on folke/trouble.nvim for that component (see
      lua/plugins/trouble.lua); icons come from mini.icons mocking
      nvim-web-devicons (see lua/plugins/mini.lua).

  HOW TO INVOKE IT
    - Nothing to invoke: it is always on. Open files / tabs, change
      mode, attach an LSP or produce diagnostics and it updates.
    - :LualineInfo and the plugin's :lua require'lualine' API exist
      for debugging; no keymaps are bound to lualine in this config.

  FEATURES
    - Sections for mode, Git branch / diff and LSP diagnostics.
    - LSP document-symbol breadcrumb via trouble.nvim statusline.
    - Tabline rendering of Neovim tabs with mode colours and
      filename-only labels.
    - Distinct minimal inactive-window layout.
    - Built-in extensions giving matching statuslines in lazy,
      trouble and other special windows.
---------------------------------------------------------------------]]


return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "folke/trouble.nvim" },
	opts = function() -- Removed unused parameters for clarity
		-- 1. Define your base Lualine options table
		local lualine_options = {
			options = {
				icons_enabled = vim.g.have_nerd_font, -- Use your global setting
				theme = "auto", -- Or 'auto', or 'powerline_dark' as you had previously
				component_separators = {
					left = "",
					right = "",
				},
				section_separators = {
					left = "",
					right = "",
				},
				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = true,
				globalstatus = false,
				refresh = {
					statusline = 1000, -- Adjusted from your previous 100 to common default
					tabline = 1000,
					winbar = 1000,
				},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff" }, -- Consider adding 'diagnostics' here or in lualine_x
				lualine_c = { {
					"filename",
					path = 1,
				} }, -- Ensure this is a table of components
				lualine_x = { "diagnostics", "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { {
					"filename",
					path = 1,
				} },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},

			tabline = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {
					{
						"tabs",
						mode = 4, -- 0 = show just tab name (usually filename), better for space
						max_length = vim.o.columns, -- use available width
						use_mode_colors = true, -- enable highlight for active tab
						tabs_color = {
							active = "lualine_a_normal", -- or define your own highlight group
							inactive = "lualine_c_inactive",
						},
						fmt = function(name)
							local filename = vim.fn.fnamemodify(name, ":t") -- Just the filename
							return filename ~= "" and filename or "[No Name]"
						end,
					},
				},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},

			winbar = {},
			inactive_winbar = {},
			extensions = { "nvim-tree", "toggleterm", "lazy", "trouble" }, -- Add trouble here for its own extension if needed
		}

		-- 2. Define and integrate the Trouble statusline component
		local trouble = require("trouble")
		local trouble_component = trouble.statusline({ -- Renamed from 'symbols'
			mode = "lsp_document_symbols", -- This shows document symbols. For error counts, use mode = "diagnostics"
			groups = {},
			title = false,
			filter = {
				range = true,
			},
			format = "{kind_icon}{symbol.name:Normal}",
			hl_group = "lualine_c_normal", -- Ensure this highlight group exists or matches your lualine theme
		})

		-- 3. Insert the Trouble component into your desired Lualine section
		--    Let's add it to the beginning of section C for this example.
		--    Make sure lualine_options.sections.lualine_c is initialized as a table.
		if type(lualine_options.sections.lualine_c) ~= "table" then
			lualine_options.sections.lualine_c = {}
		end
		table.insert(lualine_options.sections.lualine_c, 1, { -- Insert at the beginning
			trouble_component.get,
			cond = trouble_component.has,
		})

		-- 4. Return the complete options table for Lualine
		return lualine_options
	end,
}
