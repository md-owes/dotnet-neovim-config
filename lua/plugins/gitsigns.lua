--[[ ---------------------------------------------------------------------
  gitsigns.nvim - Git signs, hunks and blame in the gutter
  Repo: lewis6991/gitsigns.nvim

  WHAT IT IS
    Shows Git changes directly in the editor: a sign in the gutter for
    every added, changed or deleted line compared to HEAD / the index,
    plus hunk-level actions to stage, reset, preview and diff parts of a
    file, and blame for the current line. It is the inline, per-buffer
    Git view; for a full multi-file diff use diffview.nvim instead.

  WHY IT IS USEFUL
    - See what you changed in a file at a glance, without running git diff.
    - Stage or discard a single hunk instead of a whole file.
    - Preview a hunk in a float before deciding to keep or reset it.
    - Blame a line in place to see who changed it and in which commit.

  HOW IT IS CONFIGURED HERE
    - Sign text: add '+', change '~', delete '_', topdelete (overline),
      changedelete '~'. No other opts are set, so defaults apply for
      watchers, blame formatting and preview windows.
    - All keymaps are buffer-local and set in on_attach, so they only
      exist in buffers attached to a Git repository.
    - Navigation: ]c / [c jump to next / previous hunk; inside a real
      diff (vim.wo.diff) they fall back to the built-in ]c / [c motion.
    - Actions (normal mode):
        <leader>gh - stage hunk        <leader>gr - reset hunk
        <leader>gu - undo stage hunk   <leader>gp - preview hunk
        <leader>gm - blame line        <leader>gd - diff against index
        <leader>gD - diff against last commit (diffthis '@')
    - Actions (visual mode): <leader>gh stages and <leader>gr resets
      only the selected lines of a hunk.
    - Toggles: <leader>ub toggles current-line blame, <leader>ug
      toggles the gutter signs (both documented under [U]I in which-key).

  HOW TO INVOKE IT
    - Automatic: open any file inside a Git repo and signs appear.
    - Press ]c / [c to move between changes, then <leader>gp to preview,
      <leader>gh to stage or <leader>gr to discard that hunk.
    - Visual-select lines first, then <leader>gh / <leader>gr to stage
      or reset just that part of a hunk.
    - Commands also exist, e.g. :Gitsigns stage_hunk, :Gitsigns blame,
      :Gitsigns preview_hunk, :Gitsigns diffthis.

  FEATURES
    - Gutter signs for added / changed / deleted lines, updated live.
    - Hunk navigation, staging, unstaging, resetting and previewing.
    - Line blame and optional current-line blame toggle.
    - Diff the buffer against the index or against HEAD / any revision.
    - Works buffer-locally through on_attach, so non-Git buffers are
      left completely untouched.
---------------------------------------------------------------------]]


return {
    "lewis6991/gitsigns.nvim",
    opts = {
        signs = {
            add = { text = "+" },
            change = { text = "~" },
            delete = { text = "_" },
            topdelete = { text = "‾" },
            changedelete = { text = "~" },
        },
        on_attach = function(bufnr)
            local gitsigns = require("gitsigns")

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map("n", "]c", function()
                if vim.wo.diff then
                    vim.cmd.normal({ "]c", bang = true })
                else
                    gitsigns.nav_hunk("next")
                end
            end, { desc = "Jump to next git [c]hange" })

            map("n", "[c", function()
                if vim.wo.diff then
                    vim.cmd.normal({ "[c", bang = true })
                else
                    gitsigns.nav_hunk("prev")
                end
            end, { desc = "Jump to previous git [c]hange" })

            -- Actions
            -- visual mode
            map("v", "<leader>gh", function()
                gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, { desc = "stage git hunk" })
            map("v", "<leader>gr", function()
                gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, { desc = "reset git hunk" })
            -- normal mode
            map("n", "<leader>gh", gitsigns.stage_hunk, { desc = "git [s]tage hunk" })
            map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "git [r]eset hunk" })
            map("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "git [u]ndo stage hunk" })
            map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "git [p]review hunk" })
            map("n", "<leader>gm", gitsigns.blame_line, { desc = "git [b]lame line" })
            map("n", "<leader>gd", gitsigns.diffthis, { desc = "git [d]iff against index" })
            map("n", "<leader>gD", function()
                gitsigns.diffthis("@")
            end, { desc = "git [D]iff against last commit" })
            -- Toggles
            map("n", "<leader>ub", gitsigns.toggle_current_line_blame, { desc = "[U]I: Toggle git [b]lame line" })
            map("n", "<leader>ug", gitsigns.toggle_signs, { desc = "[U]I: Toggle [g]it gutter signs" })
        end,
    },
    keys = {},
}
