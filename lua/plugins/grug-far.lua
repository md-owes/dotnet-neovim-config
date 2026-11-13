--[[ ---------------------------------------------------------------------
  grug-far.nvim - project-wide find and replace panel
  Repo: MagicDuck/grug-far.nvim

  WHAT IT IS
    A search-and-replace UI for the whole project. It opens a dedicated
    buffer with fields for the search pattern, replacement, file filters
    and flags, runs ripgrep underneath, and lets you review every match
    and apply replacements across files from one place - far safer and
    more visible than a hand-written :grep + :cfdo substitute.

  WHY IT IS USEFUL
    - Rename identifiers, APIs or strings across an entire codebase
      with a live preview of every match before anything changes.
    - History of previous searches, so repeated refactors are one recall
      away instead of retyping patterns and paths.
    - Prefills the word under the cursor or your last search, which is
      what you want in the common rename / fix-up case.
    - Visual mode entry pre-fills the selected text as the search term.

  HOW IT IS CONFIGURED HERE
    - No explicit lazy-loading keys in the spec beyond its keymaps:
      the plugin defers its own requires, so it is lazy by default
      (noted in the comment in the spec itself).
    - history.enabled = true: previous searches are remembered and
      can be recalled inside the panel.
    - prefill_word_under_cursor = true: opening it normally seeds the
      search field with the word under the cursor.
    - prefill_last_search = true: the last search is also used as a
      prefill source when applicable.
    - Keymaps:
        <leader>fr (normal) - :GrugFar, Find & Replace in Project
        <leader>fr (visual) - :GrugFarVisual, Find & Replace Visual
                              Selection (searches for the selection)

  HOW TO INVOKE IT
    - Press <leader>fr in normal mode, fill in Search and Replace,
      review the results list, then apply from the panel (see the
      help / ? inside the panel for its local actions, sync and open).
    - Visual-select text and press <leader>fr to replace occurrences
      of exactly that selection.
    - Commands: :GrugFar and :GrugFarVisual can also be typed directly.
    - Narrow scope inside the panel with its file / path and flag
      fields before applying, e.g. to one directory or filetype.

  FEATURES
    - Ripgrep-backed project search with regex, case and word options
      exposed as panel fields rather than command-line flags.
    - Batch replace across files, with per-file results you can open.
    - Search history, word-under-cursor and last-search prefills.
    - Visual-selection search, sync / apply controls and help in-panel.
    - Pairs with the Snacks grep picker (<leader>sg) for read-only
      searching when you do not intend to replace anything.
---------------------------------------------------------------------]]


return {
	"MagicDuck/grug-far.nvim",
	-- Note (lazy loading): grug-far.lua defers all it's requires so it's lazy by default
	-- additional lazy config to defer loading is not really needed...
	opts = {
		-- Enable history, allowing you to recall previous searches.
		-- Your existing setting for this is correct!
		history = {
			enabled = true,
		},

		-- Keep the useful pre-fill options
		prefill_word_under_cursor = true,
		prefill_last_search = true,
	},
	keys = {
		-- Shortcut for standard project-wide Find & Replace
		{
			"<leader>fr",
			"<cmd>GrugFar<cr>",
			mode = "n",
			desc = "Find & Replace in Project",
		},
		{
			"<leader>fr",
			"<cmd>GrugFarVisual<cr>",
			mode = "v",
			desc = "Find & Replace Visual Selection",
		},
	},
}
