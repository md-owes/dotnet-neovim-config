--[[ ---------------------------------------------------------------------
  which-key.nvim - popup showing pending keybindings
  Repo: folke/which-key.nvim

  WHAT IT IS
    Shows a popup listing the keys you can press next after you
    start a key sequence. Press <leader> and, instead of guessing
    what follows, you get a window of the <leader> mappings with
    their descriptions; press 'g' and you see the g- motions, and
    so on. It turns the dozens of keymaps in this config - LSP,
    Git, Snacks, Trouble, tests, surround - into something
    discoverable instead of something to memorise.

  WHY IT IS USEFUL
    - You never have to remember every mapping: the popup is the
      cheat sheet, always one prefix away.
    - Group descriptions ('[C]ode', '[S]earch', 'Git [H]unk') make
      the popup read as a menu of what you can do, not a dump of keys.
    - It documents keymaps defined in other files (gitsigns, DAP,
      neotest, trouble) in one place, through the spec below.

  HOW IT IS CONFIGURED HERE
    - event = 'VimEnter': loads once Neovim has started.
    - opts.delay = 0: the popup appears immediately after the
      prefix, with no waiting; this delay is independent of
      vim.opt.timeoutlen (see lua/core/options.lua).
    - opts.icons.mappings = vim.g.have_nerd_font: mapping icons
      are shown only when a Nerd Font is available.
    - opts.icons.keys: with a Nerd Font this is an empty table,
      which uses which-key's default Nerd Font key icons; without
      one it is an explicit string table mapping Up / Down / Left /
      Right, C / M / D / S modifiers, CR, Esc, scroll wheels, NL,
      BS, Space, Tab and F1-F12 to readable labels.
    - opts.spec documents the existing key chains as groups:
        <leader>c - [C]ode (normal + visual)
        <leader>d - [D]ocument
        <leader>r - [R]ename
        <leader>s - [S]earch
        <leader>w - [W]orkspace
        <leader>T - [T]oggle
        <leader>h - Git [H]unk (normal + visual)
        <leader>u - [U]I / Toggles
        <leader>n - [N]eo-tree / Avante
        <leader>x - Diagnostics / Trouble
        gz         - Surround (mini.surround, see mini.lua)
    - Note: these spec entries only label the groups; the actual
      mappings live in their own plugin files and in
      lua/core/keymaps.lua.

  HOW TO INVOKE IT
    - Automatic: press any prefix that has further mappings, such
      as <leader>, 'g', ']' or 'gz', pause, and the popup appears.
    - Continue the sequence by pressing a key shown in the popup,
      or press <Esc> to dismiss it.
    - :WhichKey - open the popup manually; :WhichKey <prefix>
      shows the mappings under a specific prefix.

  FEATURES
    - Popup of pending keys with descriptions and group labels.
    - Shows mappings from every plugin, not just this file.
    - Nerd Font icons for keys and mappings when available.
    - Configurable delay, sorting and window layout (defaults
      are used here apart from the delay and icons above).
---------------------------------------------------------------------]]


return { -- Useful plugin to show you pending keybinds.
	"folke/which-key.nvim",
	event = "VimEnter", -- Sets the loading event to 'VimEnter'
	opts = {
		-- delay between pressing a key and opening which-key (milliseconds)
		-- this setting is independent of vim.opt.timeoutlen
		delay = 0,
		icons = {
			-- set icon mappings to true if you have a Nerd Font
			mappings = vim.g.have_nerd_font,
			-- If you are using a Nerd Font: set icons.keys to an empty table which will use the
			-- default which-key.nvim defined Nerd Font icons, otherwise define a string table
			keys = vim.g.have_nerd_font and {} or {
				Up = "<Up> ",
				Down = "<Down> ",
				Left = "<Left> ",
				Right = "<Right> ",
				C = "<C-…> ",
				M = "<M-…> ",
				D = "<D-…> ",
				S = "<S-…> ",
				CR = "<CR> ",
				Esc = "<Esc> ",
				ScrollWheelDown = "<ScrollWheelDown> ",
				ScrollWheelUp = "<ScrollWheelUp> ",
				NL = "<NL> ",
				BS = "<BS> ",
				Space = "<Space> ",
				Tab = "<Tab> ",
				F1 = "<F1>",
				F2 = "<F2>",
				F3 = "<F3>",
				F4 = "<F4>",
				F5 = "<F5>",
				F6 = "<F6>",
				F7 = "<F7>",
				F8 = "<F8>",
				F9 = "<F9>",
				F10 = "<F10>",
				F11 = "<F11>",
				F12 = "<F12>",
			},
		},

		-- Document existing key chains
		spec = {
			{
				"<leader>c",
				group = "[C]ode",
				mode = { "n", "x" },
			},
			{
				"<leader>d",
				group = "[D]ocument",
			},
			{
				"<leader>r",
				group = "[R]ename",
			},
			{
				"<leader>s",
				group = "[S]earch",
			},
			{
				"<leader>w",
				group = "[W]orkspace",
			},
			{
				"<leader>T",
				group = "[T]oggle",
			},
			{
				"<leader>h",
				group = "Git [H]unk",
				mode = { "n", "v" },
			},
			{
				"<leader>u",
				group = "[U]I / Toggles",
			},
			{
				"<leader>n",
				group = "[N]eo-tree / Avante",
			},

			{
				"<leader>x",
				group = "Diagnostics / Trouble",
			},
			{
				"gz",
				group = "Surround",
			},
		},
	},
}
