--[[ ---------------------------------------------------------------------
  lazydev.nvim - Lua LSP setup for editing your Neovim config
  Repo: folke/lazydev.nvim

  WHAT IT IS
    Configures the Lua language server (lua_ls) specifically for Neovim
    config and plugin development. It teaches lua_ls about the Neovim
    runtime, the vim.* API and your installed plugins, so editing Lua
    in ~/.config/nvim gets correct completions, type annotations,
    signatures and diagnostics instead of 'undefined global vim' noise.
    It replaces the older neodev.nvim.

  WHY IT IS USEFUL
    - vim.api, vim.opt, vim.keymap and friends complete and are typed
      while you edit your own config, just like a real library.
    - Plugin APIs from installed plugins become known to lua_ls, so
      calls into Snacks, blink.cmp and others check properly.
    - No manual lua_ls library paths to maintain in lspconfig: lazydev
      injects the right libraries per buffer and per project.

  HOW IT IS CONFIGURED HERE
    - ft = 'lua': the plugin only loads for Lua buffers, so it costs
      nothing in other filetypes.
    - library: loads the luvit types at ${3rd}/luv/library only when
      the word pattern 'vim%.uv' appears in the buffer, giving correct
      types for vim.uv / libuv calls without loading them everywhere.
    - No other opts: workspace library detection for Neovim runtime
      files and for plugins in the lazy.nvim spec is on by default.
    - The lua_ls server itself is enabled in
      lua/plugins/nvim-lspconfig.lua; lazydev only supplies its
      library / workspace configuration.

  HOW TO INVOKE IT
    - Nothing to invoke: open any .lua file (for example a file under
      lua/plugins or lua/core) and it activates automatically.
    - :LazyDev or :checkhealth lazydev can be used to inspect its
      state if completions for vim.* look wrong.
    - Effects are visible through blink.cmp completions and lua_ls
      hover / signature help while editing Lua.

  FEATURES
    - Automatic Neovim runtime and plugin library injection for lua_ls.
    - Word-triggered extra libraries (here: luv types on 'vim.uv').
    - Correct globals and annotations for the vim API, removing false
      diagnostics in config files.
    - Per-buffer, on-demand loading: inactive outside Lua files.
---------------------------------------------------------------------]]


return {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
        library = { -- Load luvit types when the `vim.uv` word is found
        {
            path = "${3rd}/luv/library",
            words = {"vim%.uv"}
        }}
    }
}
