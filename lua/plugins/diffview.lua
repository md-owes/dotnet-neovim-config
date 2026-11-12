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
