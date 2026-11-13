--[[ ---------------------------------------------------------------------
  leap.nvim - jump anywhere with a two-character motion
  Repo: andyg/leap.nvim (loaded from codeberg.org/andyg/leap.nvim)

  WHAT IT IS
    A motion plugin: type a short prefix plus two target characters
    and Leap labels every matching position on screen, then one more
    keypress jumps straight there. It generalises f / t and search
    into a single fast, low-keystroke way to reach any visible text,
    forwards, backwards, or even in another window.

  WHY IT IS USEFUL
    - Reach any visible word in a few keystrokes instead of repeated
      w / b / e, counts, or a full search-and-<CR> cycle.
    - Works as an operator-pending motion, so it composes with d, c,
      y and visual mode: delete or change up to a far-away point.
    - leap-from-window jumps between splits without window navigation.
    - Labels disambiguate repeated matches, so no counting duplicates.

  HOW IT IS CONFIGURED HERE
    - Loaded from its Codeberg URL rather than a GitHub repo name.
    - Lazy-loaded on its keys; no setup() opts are passed, so Leap's
      defaults apply for labels, highlighting and case behaviour.
    - Keymaps, all in normal, visual and operator-pending modes:
        <leader>i - <Plug>(leap-forward): leap forwards in the window
        <leader>I - <Plug>(leap-backward): leap backwards
        <leader>G - <Plug>(leap-from-window): leap to another window
    - Note <leader>i / <leader>I intentionally shadow nothing else in
      this config, and <leader>G is distinct from the Git <leader>g*
      prefix used by gitsigns and diffview.

  HOW TO INVOKE IT
    - Press <leader>i, type the two characters you want to jump to,
      then press the label shown at the target (if there are several
      matches); with a unique match Leap jumps immediately.
    - Use it with an operator, e.g. d<leader>i.. to delete up to a
      target, or v<leader>i.. to extend the selection to it.
    - <leader>I is the same idea upwards; <leader>G starts the leap
      from the other windows on screen.

  FEATURES
    - Forward, backward and cross-window leaps with labelled targets.
    - Composes with operators and visual mode like a native motion.
    - Automatic jump when the two characters have a single match.
    - Bi-directional and multi-window variants are available from the
      plugin itself; only the three mappings above are bound here.
---------------------------------------------------------------------]]


return {
	url = "https://codeberg.org/andyg/leap.nvim",
	keys = {
		{
			"<leader>i",
			"<Plug>(leap-forward)",
			mode = { "n", "x", "o" },
			desc = "Leap forward",
		},
		{
			"<leader>I",
			"<Plug>(leap-backward)",
			mode = { "n", "x", "o" },
			desc = "Leap backward",
		},
		{
			"<leader>G",
			"<Plug>(leap-from-window)",
			mode = { "n", "x", "o" },
			desc = "Leap from window",
		},
	},
}
