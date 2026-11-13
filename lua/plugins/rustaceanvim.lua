--[[ ---------------------------------------------------------------------
  rustaceanvim - rust-analyzer integration for Rust
  Repo: mrcjkb/rustaceanvim

  WHAT IT IS
    The Rust language-server plugin. Unlike a plain lspconfig entry
    for rust-analyzer, rustaceanvim manages the server itself and
    adds Rust-specific behaviour on top: runnables (run / test a
    function from code lens), debugging through codelldb, hover
    actions, explain-error, expand-macro, move-item and other
    Rust-only commands, plus test output handling. It is the
    standard way to get a full Rust IDE experience in Neovim.

  WHY IT IS USEFUL
    - Rust development without leaving Neovim: run and debug tests
      and binaries from the buffer you are editing.
    - rust-analyzer diagnostics, inlay hints and completions with
      the same blink.cmp capabilities as every other server here.
    - Rust-specific actions (explain error, expand macro, run a
      single test) that a generic LSP client cannot offer.
    - The server binary (rust-analyzer) is installed by Mason - see
      the ensure_installed list in lua/plugins/nvim-lspconfig.lua;
      the debug adapter codelldb is installed from the same list
      and used by nvim-dap (see lua/plugins/nvim-dap.lua).

  HOW IT IS CONFIGURED HERE
    - version = '^6', lazy = false: loads at startup, pinned to
      major version 6.
    - config() sets only vim.g.rustaceanvim.server.capabilities =
      require('blink.cmp').get_lsp_capabilities(), so completion
      matches the rest of the config (see lua/plugins/blink.lua).
    - Everything else is rustaceanvim defaults: server settings,
      inlay hints, runnables, code lenses and DAP integration are
      left at their defaults, and rust-analyzer itself is NOT
      listed in the nvim-lspconfig servers table - rustaceanvim
      owns it, and adding it there would start a second server.

  HOW TO INVOKE IT
    - Automatic: open a .rs file and rust-analyzer starts.
    - The shared LSP keymaps apply: gd / gr / <leader>rn /
      <leader>ca / K hover / ]d / [d - see nvim-lspconfig.lua.
    - :RustLsp <command> - Rust commands, e.g. :RustLsp
      explainError, expandMacro, runnables, testables, debuggables.
    - Code lenses above functions offer Run / Test / Debug actions.
    - Formatting for Rust is rustfmt via conform.nvim
      (see lua/plugins/conform.lua).

  FEATURES
    - rust-analyzer LSP: definitions, references, rename, actions.
    - Runnables and testables with inline results.
    - Debugging integration (codelldb via nvim-dap).
    - Hover actions, explain-error and macro expansion.
    - Inlay hints and code lenses, on by default.
---------------------------------------------------------------------]]


return {
	"mrcjkb/rustaceanvim",
	version = "^6",
	lazy = false,
	config = function()
		vim.g.rustaceanvim = {
			server = {
				capabilities = require("blink.cmp").get_lsp_capabilities(),
			},
		}
	end,
}
