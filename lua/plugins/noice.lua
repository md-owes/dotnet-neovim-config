--[[ ---------------------------------------------------------------------
  noice.nvim - replacement UI for messages, cmdline and popupmenu
  Repo: folke/noice.nvim

  WHAT IT IS
    Replaces Neovim's built-in UI for : messages, the command line
    and the completion popupmenu with floating, filterable views
    built on nui.nvim. Notifications are routed to nvim-notify.
    It is why the cmdline appears as a centred palette and long
    messages open in a split instead of a 'press ENTER' prompt.

  WHY IT IS USEFUL
    - Messages no longer disappear or block the screen: they are
      kept, searchable and routed by kind / level.
    - The command palette groups cmdline and popupmenu together,
      which makes ':' and '/' far easier to read and complete.
    - LSP hover / signature markdown is rendered with Treesitter
      highlighting through the overrides below.
    - Pairs with Snacks: Snacks' own notifier is disabled in
      lua/plugins/snacks.lua because Noice / nvim-notify owns
      vim.notify in this config.

  HOW IT IS CONFIGURED HERE
    - event = 'VeryLazy'; dependencies MunifTanjim/nui.nvim and
      rcarriga/nvim-notify.
    - lsp.progress.enabled = false: no Noice progress popups for
      LSP work (fidget.nvim, loaded with nvim-lspconfig, is left
      to surface LSP status instead).
    - lsp.override: both true, so LSP docs use Treesitter markdown:
        vim.lsp.util.convert_input_to_markdown_lines = true
        vim.lsp.util.stylize_markdown = true
    - presets:
        bottom_search = true       - '/' search stays at the bottom
        command_palette = true     - cmdline + popupmenu together
        long_message_to_split = true - long messages go to a split
        inc_rename = false         - no inc-rename.nvim dialog
        lsp_doc_border = false     - no border on hover / signature
    - No keymaps or cmdline / message view overrides are set here,
      so formats, routes and views are Noice defaults.

  HOW TO INVOKE IT
    - Automatic: type ':', '/' or trigger any message / notify.
    - :Noice          - open the message history view.
    - :Noice history / :Noice last / :Noice errors - filtered views.
    - :Noice dismiss  - dismiss all visible notifications.
    - :Noice disable / :Noice enable - toggle it if the stock UI
      is needed for debugging a message or rendering problem.

  FEATURES
    - Floating cmdline, popupmenu and message views with history.
    - Notification routing to nvim-notify with levels and timeouts.
    - Treesitter-highlighted LSP hover and signature help content.
    - Searchable, filterable log of every message Neovim emitted.
    - Preset layouts for search, palette and long messages.
---------------------------------------------------------------------]]


return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	opts = {
		lsp = {
			progress = {
				enabled = false,
			},
			-- Override markdown rendering so LSP docs use Treesitter.
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
			},
		},
		presets = {
			bottom_search = true, -- classic bottom cmdline for search
			command_palette = true, -- position the cmdline and popupmenu together
			long_message_to_split = true, -- long messages go to a split
			inc_rename = false, -- input dialog for inc-rename.nvim
			lsp_doc_border = false, -- border for hover docs and signature help
		},
	},
}
