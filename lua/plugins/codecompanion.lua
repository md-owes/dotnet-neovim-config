return {
    "olimorris/codecompanion.nvim",
    opts = {},
    config = function()
        require("codecompanion").setup({
            adapters = {
                gemini = function()
                    return require("codecompanion.adapters").extend("gemini", {
                        env = {
                            api_key = "AIzaSyCKtHU67myoKPh7zf366oabi1BI4K7t_vE"
                        }
                    })
                end
            },
            strategies = {
                chat = {
                    adapter = "gemini"
                },
                inline = {
                    adapter = "gemini"
                },
                cmd = {
                    adapter = "gemini"
                }
            }
        })

        vim.cmd([[cab cc CodeCompanion]])
    end,
    dependencies = {"nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter"},
    keys = {{
        "<C-a>",
        "<cmd>CodeCompanionActions<cr>",
        mode = {"n", "v"},
        desc = "CodeCompanion Actions"
    }, {
        "<C-c>",
        "<cmd>CodeCompanion<cr>",
        mode = {"n", "v"},
        desc = "CodeCompanion"
    }, {
        "<C-t>",
        "<cmd>CodeCompanionChat Toggle<cr>",
        mode = {"n", "v"},
        desc = "CodeCompanion Chat Toggle"
    }, {
        "<C-d>",
        "<cmd>CodeCompanionCmd<cr>",
        mode = {"n", "v"},
        desc = "CodeCompanion Command"
    }}
}
