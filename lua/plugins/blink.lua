--[[ ---------------------------------------------------------------------
  blink.cmp - fast, Rust-powered completion engine
  Repo: saghen/blink.cmp

  WHAT IT IS
    The completion engine for this config. As you type it shows a popup
    menu of completions from the LSP, file paths, snippets, open buffers
    and extra sources, with fuzzy matching, signature help and docs.
    It replaces nvim-cmp: it is written with a Rust core, so matching and
    sorting stay fast even with many candidates.

  WHY IT IS USEFUL
    - Context-aware suggestions: LSP symbols, function signatures, paths
      and snippets in one menu, ranked together.
    - Fast fuzzy matching in Rust, so typing never feels laggy.
    - Signature help while typing function arguments.
    - Extensible: Avante and ecolog plug in as extra completion sources.

  HOW IT IS CONFIGURED HERE
    - keymap preset = 'default' (standard blink.cmp insert-mode keys).
    - appearance.nerd_font_variant = 'mono' for icon alignment.
    - Default sources, in priority order:
        lsp, path, snippets, buffer,
        avante_commands, avante_mentions, avante_files, ecolog
    - Provider details (higher score_offset ranks higher):
        avante_mentions: score_offset 1000, via blink.compat.source
        avante_files:    score_offset 100,  via blink.compat.source
        avante_commands: score_offset 90,   via blink.compat.source
        ecolog:          score_offset 50,   via ecolog.integrations.cmp.blink_cmp
    - signature.enabled = true: function signature help is shown.
    - completion.documentation.auto_show = false: docs do not pop up
      automatically; open them on demand instead.
    - fuzzy.implementation = 'rust' for the fast native matcher.
    - opts_extend = { 'sources.default' }: other specs can add sources.
    - Build step runs require('blink.cmp').build():pwait() to compile
      the Rust helper via blink.lib.

  HOW TO INVOKE IT
    - Automatic: start typing in insert mode and the menu appears.
    - With the 'default' preset: Ctrl-Space shows / hides the menu,
      Ctrl-n / Ctrl-p (or Up / Down) moves through items, Enter or
      Ctrl-y accepts, Ctrl-e cancels. See ':h blink-cmp' for the full list.
    - LSP capabilities from blink.cmp are shared with every language
      server - see lua/plugins/nvim-lspconfig.lua and roslyn.lua.

  FEATURES
    - LSP completions with kind icons, plus path, snippet and buffer text.
    - Snippets from friendly-snippets (via rafamadriz/friendly-snippets).
    - Signature help popups while filling in call arguments.
    - Documentation popup on demand for the selected item.
    - nvim-cmp source compatibility through saghen/blink.compat, used
      here for the three Avante sources.
    - Env-var completions from ecolog.nvim (see lua/plugins/ecolog.lua).

  DEPENDENCIES
    - saghen/blink.lib (Rust core), rafamadriz/friendly-snippets,
      saghen/blink.compat (lazy-loaded, for cmp-compatible sources).
---------------------------------------------------------------------]]


return {
	"saghen/blink.cmp",
	dependencies = {
		"saghen/blink.lib",
		"rafamadriz/friendly-snippets",
		{ "saghen/blink.compat", lazy = true, opts = {} },
	},
	build = function()
		-- `pwait` is defined on the blink.lib.Task returned by build();
		-- lua_ls cannot infer it, so suppress only this warning.
		---@diagnostic disable-next-line: undefined-field
		require("blink.cmp").build():pwait()
	end,
	opts = {
		keymap = { preset = "default" },
		appearance = {
			nerd_font_variant = "mono",
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer", "avante_commands", "avante_mentions", "avante_files", "ecolog" },
			providers = {
				avante_commands = {
					name = "avante_commands",
					module = "blink.compat.source",
					score_offset = 90,
					opts = {},
				},
				avante_files = {
					name = "avante_files",
					module = "blink.compat.source",
					score_offset = 100,
					opts = {},
				},
				avante_mentions = {
					name = "avante_mentions",
					module = "blink.compat.source",
					score_offset = 1000,
					opts = {},
				},
				ecolog = {
					name = "ecolog",
					module = "ecolog.integrations.cmp.blink_cmp",
					score_offset = 50,
				},
			},
		},
		signature = { enabled = true },
		completion = { documentation = { auto_show = false } },
		fuzzy = { implementation = "rust" },
	},
	opts_extend = { "sources.default" },
}
