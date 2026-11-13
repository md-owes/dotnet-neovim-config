--[[ ---------------------------------------------------------------------
  trouble.nvim - diagnostics, symbols and list viewer
  Repo: folke/trouble.nvim

  WHAT IT IS
    A pretty list viewer for everything that is normally a flat list
    in Neovim: LSP diagnostics, document symbols, LSP locations,
    the location list and the quickfix list. Instead of jumping
    through errors one by one with ]d / [d, Trouble opens a window
    listing them all, grouped and filterable, and Enter jumps to the
    selected item. It is the list counterpart to the inline signs
    from gitsigns.nvim and the diagnostic virtual text configured
    in lua/plugins/nvim-lspconfig.lua.

  WHY IT IS USEFUL
    - See every error and warning in a file or project at once,
      instead of discovering them one jump at a time.
    - The symbols view is an outline of the current file (classes,
      functions, methods) for fast navigation.
    - Quickfix and location lists become readable, filterable
      windows instead of raw :copen output.
    - Its statusline component feeds the breadcrumb in lualine
      (see lua/plugins/lualine.lua), showing where you are in a file.

  HOW IT IS CONFIGURED HERE
    - lazy = true, cmd = 'Trouble': loads only when the :Trouble
      command or one of the keymaps below is used.
    - opts = {}: all defaults apply for window layout, modes,
      grouping, sorting and icons; see ':h trouble' for the
      configuration section if custom setup is ever needed.
    - Keymaps (normal mode, all toggle their view):
        <leader>xx - Diagnostics (Trouble):
                     :Trouble diagnostics toggle
        <leader>xX - Buffer Diagnostics:
                     :Trouble diagnostics toggle filter.buf=0
        <leader>xs - Symbols: :Trouble symbols toggle focus=false
        <leader>xl - LSP Locations:
                     :Trouble lsp toggle focus=false win.position=right
        <leader>xL - Location List: :Trouble loclist toggle
        <leader>xQ - Quickfix List: :Trouble qflist toggle
    - The '<leader>x' prefix is documented as the 'Diagnostics /
      Trouble' group in which-key (see lua/plugins/which-key.lua).

  HOW TO INVOKE IT
    - Press one of the keymaps above to open or close its view.
    - :Trouble diagnostics / symbols / lsp / loclist / qflist -
      the same views as commands, with 'toggle' to open or close.
    - Inside a Trouble window: Enter jumps to the item, <CR> on a
      group expands it, 'q' closes the window; see ':h trouble'
      for the full list of window-local keys.
    - :Trouble diagnostics toggle filter.buf=0 limits the list to
      the current buffer; without the filter it covers the project.

  FEATURES
    - Diagnostics list for the buffer or the whole workspace.
    - Document symbols outline and LSP locations / references list.
    - Quickfix and location list rendering with filtering.
    - Grouping, sorting and preview of items before jumping.
    - Statusline component (trouble.statusline) used by lualine
      for the LSP document-symbol breadcrumb.
---------------------------------------------------------------------]]


return {
    "folke/trouble.nvim",
    lazy = true,
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = { {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)"
    }, {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics"
    }, {
        "<leader>xs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols"
    }, {
        "<leader>xl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Locations"
    }, {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List"
    }, {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List"
    } }
}
