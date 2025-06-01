return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function() -- Removed unused parameters for clarity
        -- 1. Define your base Lualine options table
        local lualine_options = {
            options = {
                icons_enabled = vim.g.have_nerd_font, -- Use your global setting
                theme = "tokyonight",                 -- Or 'auto', or 'powerline_dark' as you had previously
                component_separators = {
                    left = "",
                    right = ""
                },
                section_separators = {
                    left = "",
                    right = ""
                },
                disabled_filetypes = {
                    statusline = {},
                    winbar = {}
                },
                ignore_focus = {},
                always_divide_middle = true,
                globalstatus = false,
                refresh = {
                    statusline = 1000, -- Adjusted from your previous 100 to common default
                    tabline = 1000,
                    winbar = 1000
                }
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff" }, -- Consider adding 'diagnostics' here or in lualine_x
                lualine_c = { {
                    "filename",
                    path = 1
                } }, -- Ensure this is a table of components
                lualine_x = { "diagnostics", "encoding", "fileformat", "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location" }
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { {
                    "filename",
                    path = 1
                } },
                lualine_x = { "location" },
                lualine_y = {},
                lualine_z = {}
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = { "nvim-tree", "toggleterm", "lazy", "trouble" } -- Add trouble here for its own extension if needed
        }

        -- 2. Define and integrate the Trouble statusline component
        local trouble = require("trouble")
        local trouble_component = trouble.statusline({ -- Renamed from 'symbols'
            mode = "lsp_document_symbols",             -- This shows document symbols. For error counts, use mode = "diagnostics"
            groups = {},
            title = false,
            filter = {
                range = true
            },
            format = "{kind_icon}{symbol.name:Normal}",
            hl_group = "lualine_c_normal" -- Ensure this highlight group exists or matches your lualine theme
        })

        -- 3. Insert the Trouble component into your desired Lualine section
        --    Let's add it to the beginning of section C for this example.
        --    Make sure lualine_options.sections.lualine_c is initialized as a table.
        if type(lualine_options.sections.lualine_c) ~= "table" then
            lualine_options.sections.lualine_c = {}
        end
        table.insert(lualine_options.sections.lualine_c, 1, { -- Insert at the beginning
            trouble_component.get,
            cond = trouble_component.has
        })

        -- 4. Return the complete options table for Lualine
        return lualine_options
    end
}
