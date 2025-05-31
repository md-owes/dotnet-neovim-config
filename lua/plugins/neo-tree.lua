return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {"nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim"},
    opts = {
        sources = {"filesystem", "buffers", "git_status", "diagnostics"},
        use_libuv_file_watcher = true,
        diagnostics = {
            enable = true,
            show_on_dirs = true,
            show_on_open_dirs = false
        },
        default_component_configs = {
            diagnostics = {
                symbols = {
                    hint = "",
                    info = "",
                    warn = "",
                    error = ""
                }
            }
        }
    }
}
