return {
    "lewis6991/gitsigns.nvim",
    opts = {
        signs = {
            add = {
                text = "+"
            },
            change = {
                text = "~"
            },
            delete = {
                text = "_"
            },
            topdelete = {
                text = "‾"
            },
            changedelete = {
                text = "~"
            }
        }
    },
    keys = {{
        "<leader>gm",
        "<cmd>Gitsigns blame_line<cr>",
        desc = "Git Blame"
    }, {
        "<leader>gp",
        "<cmd>Gitsigns preview_hunk<cr>",
        desc = "Preview Hunk"
    }, {
        "<leader>gh",
        "<cmd>Gitsigns stage_hunk<cr>",
        desc = "Stage Hunk"
    }, {
        "<leader>gu",
        "<cmd>Gitsigns undo_stage_hunk<cr>",
        desc = "Undo Stage Hunk"
    }, {
        "<leader>gr",
        "<cmd>Gitsigns reset_hunk<cr>",
        desc = "Reset Hunk"
    }, {
        "<leader>gg",
        "<cmd>Gitsigns toggle_signs<cr>",
        desc = "Toggle Signs"
    }}
}
