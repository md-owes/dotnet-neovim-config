--[[ ---------------------------------------------------------------------
  diffview.nvim - Git diff and file-history viewer
  Repo: sindrets/diffview.nvim

  WHAT IT IS
    A full Git diff UI inside Neovim. It opens a dedicated tab showing
    changed files in a file panel and side-by-side diffs for the selected
    file, plus a file-history view that walks the commits touching a file.
    It is the visual counterpart to gitsigns.nvim (which shows inline
    hunks in the buffer) - use Diffview when you want to review a whole
    changeset at once.

  WHY IT IS USEFUL
    - Review uncommitted changes, staged changes, or any commit range
      before committing or pushing.
    - See the history of one file and how each commit changed it.
    - Browse merge conflicts and compare branches without leaving Neovim.
    - The file panel makes it easy to jump between all changed files.

  HOW IT IS CONFIGURED HERE
    - Lazy-loaded on its commands only; no opts are set, so all defaults
      apply (default layout, file panel on the left, diffs in splits).
    - Commands that trigger loading: DiffviewOpen, DiffviewClose,
      DiffviewToggleFiles, DiffviewFocusFiles, DiffviewFileHistory.
    - Keymaps (normal mode):
        <leader>gH - Diff File History: :DiffviewFileHistory %
                      (history of the current file)
        <leader>gx - Close Diffview: :DiffviewClose
        <leader>gF - Focus Files in Diffview: :DiffviewFocusFiles
        <leader>gt - Toggle Files in Diffview: :DiffviewToggleFiles

  HOW TO INVOKE IT
    - :DiffviewOpen            - diff of uncommitted changes vs HEAD.
    - :DiffviewOpen HEAD~2     - diff against an older revision.
    - :DiffviewOpen main...HEAD - compare branches (any rev range works).
    - :DiffviewFileHistory %   - history of the current file (or
      :DiffviewFileHistory <path> for another file).
    - <leader>gH / <leader>gx / <leader>gF / <leader>gt as listed above.
    - Inside the file panel: Enter opens the diff, Tab / S-Tab moves
      between panel and diff, 'q' / :DiffviewClose quits.

  FEATURES
    - Multi-file diff view with a file panel and per-file diffs.
    - File history with per-commit diffs.
    - Diff against index, HEAD, any commit, branch or range.
    - Merge-conflict layout (diff3) when resolving conflicts.
    - Folding and navigation inside large diffs; integrates with the
      quickfix list for jumping between changed files.
---------------------------------------------------------------------]]


return {
    "sindrets/diffview.nvim",
    cmd = {"DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory"},
    keys = {{
        "<leader>gH",
        "<cmd>DiffviewFileHistory %<cr>",
        desc = "Diff File History"
    }, {
        "<leader>gx",
        "<cmd>DiffviewClose<cr>",
        desc = "Close Diffview"
    }, {
        "<leader>gF",
        "<cmd>DiffviewFocusFiles<cr>",
        desc = "Focus Files in Diffview"
    }, {
        "<leader>gt",
        "<cmd>DiffviewToggleFiles<cr>",
        desc = "Toggle Files in Diffview"
    }}
}
