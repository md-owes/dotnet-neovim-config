--[[ ---------------------------------------------------------------------
  vim-sleuth - automatic indent detection
  Repo: tpope/vim-sleuth

  WHAT IT IS
    Detects the indentation style of the file you open - how many
    spaces a tab is worth, and whether indentation uses tabs or
    spaces - by looking at the file's own contents and at
    neighbouring files, and sets shiftwidth and expandtab to match.
    It is the reason files keep their existing style without any
    per-project or per-filetype indent settings in this config:
    a two-space project stays two-space, a tab-indented file stays
    tab-indented, even when the global defaults say otherwise.

  WHY IT IS USEFUL
    - No more reformatting a file's indentation by accident when
      you edit a project whose style differs from your defaults.
    - Zero configuration: it works from the file itself, so new
      projects and languages need no new settings.
    - It respects .editorconfig-style signals from the surrounding
      files when the current file has too little indentation to
      judge on its own.

  HOW IT IS CONFIGURED HERE
    - return { 'tpope/vim-sleuth', lazy = false }: the whole spec
      is one line - it loads at startup with no opts, no config()
      function and no keymaps.
    - Everything is defaults: detection runs on BufReadPost for
      every buffer, heuristics are the plugin's own, and there is
      nothing to tune in this file.

  HOW TO INVOKE IT
    - Nothing to invoke: open any file and shiftwidth / expandtab
      are set automatically for that buffer.
    - :Sleuth - re-run detection for the current buffer and echo
      what it decided (useful when a file's style looks wrong).
    - :set shiftwidth? expandtab? - inspect what Sleuth chose.
    - Setting shiftwidth or expandtab manually in a buffer
      overrides Sleuth for that buffer only.

  FEATURES
    - Heuristic detection of shiftwidth and tab vs spaces.
    - Neighbouring-file fallback when the buffer is too short.
    - Works for any filetype, with no per-language configuration.
    - Pairs with conform.nvim (see lua/plugins/conform.lua):
      Sleuth decides the indent width, the formatter applies it.
---------------------------------------------------------------------]]


return { "tpope/vim-sleuth", lazy = false }
