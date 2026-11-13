--[[ ---------------------------------------------------------------------
  todo-comments.nvim - highlight and navigate TODO / FIXME comments
  Repo: folke/todo-comments.nvim

  WHAT IT IS
    Finds and highlights special keywords in comments - TODO, FIXME,
    NOTE, HACK, WARN, PERF, TEST and others - colouring the keyword
    and its line so actionable notes stand out from ordinary comments.
    It also provides commands to jump between them and to collect
    them into the quickfix list, location list or Trouble (see
    lua/plugins/trouble.lua), so a codebase-wide TODO review is one
    command instead of a manual grep.

  WHY IT IS USEFUL
    - TODOs and FIXMEs stop being invisible: they are coloured in
      every file you open, so unfinished work is hard to miss.
    - One list of every TODO in the project makes it easy to triage
      tech debt before a release or a handover.
    - Works with the highlighting and search tools already in this
      config (Treesitter, Trouble, Snacks pickers) instead of adding
      a separate workflow.

  HOW IT IS CONFIGURED HERE
    - event = { 'BufReadPost', 'BufNewFile' }: loads when a file is
      read or a new file is created, so it costs nothing on startup
      before any buffer exists.
    - Dependency: nvim-lua/plenary.nvim.
    - opts = { signs = false }: no gutter signs are shown for
      todo comments; only the in-buffer highlighting is used.
    - No other opts are set, so the default keyword set, colours
      and highlight styles apply (TODO, FIXME, HACK, WARN, PERF,
      NOTE, TEST and their aliases).
    - No keymaps are defined in this file; use the commands below.

  HOW TO INVOKE IT
    - Automatic: open any file and TODO / FIXME / NOTE keywords in
      comments are highlighted in place.
    - ]t / [t - jump to the next / previous todo comment (the
      plugin's default motions).
    - :TodoTelescope / :TodoQuickFix / :TodoLocList - collect all
      todo comments into Telescope, the quickfix list or the
      location list.
    - :TodoTrouble - show them in Trouble; :TodoTelescope with a
      keyword argument filters, e.g. :TodoTelescope FIXME.

  FEATURES
    - Keyword highlighting with per-keyword colours and icons.
    - Navigation between todo comments in a buffer.
    - Project-wide search and listing via quickfix, loclist,
      Telescope and Trouble.
    - Custom keywords and colours are supported by the plugin,
      though none are customised in this config.
---------------------------------------------------------------------]]


return {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
        signs = false
    }
}
