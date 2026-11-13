--[[ ---------------------------------------------------------------------
  supermaven.nvim - AI inline code completion (ghost text)
  Repo: supermaven-inc/supermaven-nvim

  WHAT IT IS
    An AI inline-completion plugin. As you type it suggests the next
    chunk of code as dimmed ghost text after the cursor, which you
    can accept in full, accept one word at a time, or dismiss. It is
    different from Avante (see lua/plugins/avante.lua): Avante is a
    chat sidebar for asking questions and requesting edits, while
    Supermaven is silent, inline completion while you type. It is
    also different from blink.cmp (see lua/plugins/blink.lua),
    which shows a popup menu of LSP / path / snippet completions;
    Supermaven predicts whole lines and blocks from context.

  WHY IT IS USEFUL
    - Boilerplate, repeated patterns and obvious next lines are
      completed with one keypress instead of typed out.
    - Accepting a single word lets you steer a long suggestion
      instead of taking it all or nothing.
    - It works in almost every filetype, so the same workflow
      applies in Lua, Python, TypeScript, C# and the rest.

  HOW IT IS CONFIGURED HERE
    - No lazy-loading keys are set, so it loads with the rest of
      the startup plugins and is active in normal editing.
    - keymaps:
        <C-a> - accept_suggestion (accept the whole suggestion)
        <C-]> - clear_suggestion (dismiss the suggestion)
        <C-j> - accept_word (accept only the next word of it)
    - ignore_filetypes = { cpp = true }: inline completion is
      disabled in C++ files.
    - color.suggestion_color = '#ffffff', cterm = 244: ghost text
      is rendered in white / grey 244 so it is visible but clearly
      distinct from real code.
    - log_level = 'info': informational logging; set to 'off' to
      disable logging completely.
    - disable_inline_completion = false: inline completion is on.
    - disable_keymaps = false: the built-in keymaps above are on;
      set to true for fully manual control.

  HOW TO INVOKE IT
    - Automatic: type in insert mode and a suggestion appears as
      ghost text after the cursor when one is available.
    - <C-a> accepts it, <C-j> accepts the next word only, <C-]>
      clears it and keeps typing.
    - No commands or leader keymaps are bound to Supermaven here;
      it has no picker or sidebar to open.

  FEATURES
    - Whole-line and multi-line inline suggestions.
    - Word-by-word acceptance for partial use of a suggestion.
    - Per-filetype disabling (here: C++).
    - Configurable suggestion colour and log level.
    - Runs alongside blink.cmp: the popup menu and ghost text
      are separate completion paths and do not replace each other.
---------------------------------------------------------------------]]


return {
	"supermaven-inc/supermaven-nvim",
	config = function()
		require("supermaven-nvim").setup({
			keymaps = {
				accept_suggestion = "<C-a>",
				clear_suggestion = "<C-]>",
				accept_word = "<C-j>",
			},
			ignore_filetypes = { cpp = true }, -- or { "cpp", }
			color = {
				suggestion_color = "#ffffff",
				cterm = 244,
			},
			log_level = "info", -- set to "off" to disable logging completely
			disable_inline_completion = false, -- disables inline completion for use with cmp
			disable_keymaps = false, -- disables built in keymaps for more manual control
		})
	end,
}
