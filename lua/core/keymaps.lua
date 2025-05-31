local keymap = vim.keymap.set

-- Basic
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>")
keymap("n", "<leader>q", vim.diagnostic.setloclist, {
    desc = "Open diagnostic [Q]uickfix list"
})

-- Terminal
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", {
    desc = "Exit terminal mode"
})

-- Window Navigation
keymap("n", "<C-h>", "<C-w><C-h>", {
    desc = "Move focus to the left window"
})
keymap("n", "<C-l>", "<C-w><C-l>", {
    desc = "Move focus to the right window"
})
keymap("n", "<C-j>", "<C-w><C-j>", {
    desc = "Move focus to the lower window"
})
keymap("n", "<C-k>", "<C-w><C-k>", {
    desc = "Move focus to the upper window"
})

vim.api.nvim_set_keymap("n", "<C-z>", ":NvimTreeToggle<cr>", {
    silent = true,
    noremap = true
})
-- Workspace diagnostics trigger (requires workspace-diagnostics plugin)
vim.api.nvim_set_keymap("n", "<C-x>", "", {
    noremap = true,
    callback = function()
        for _, client in ipairs(vim.lsp.get_clients()) do
            require("workspace-diagnostics").populate_workspace_diagnostics(client, 0)
        end
    end
})

vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        local keymap = vim.keymap.set

        -- Neo-tree
        keymap("n", "<leader>e", "<cmd>Neotree filesystem reveal float<CR>", {
            desc = "Neo-tree reveal (float)"
        })
        keymap("n", "<leader>b", "<cmd>Neotree buffers toggle<CR>", {
            desc = "Neo-tree Buffers"
        })
        keymap("n", "<leader>g", "<cmd>Neotree git_status toggle<CR>", {
            desc = "Neo-tree Git"
        })

        -- Gitsigns
        keymap("n", "<leader>gm", "<cmd>Gitsigns blame_line<cr>", {
            desc = "Git Blame"
        })
        keymap("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", {
            desc = "Preview Hunk"
        })
        keymap("n", "<leader>gh", "<cmd>Gitsigns stage_hunk<cr>", {
            desc = "Stage Hunk"
        })
        keymap("n", "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>", {
            desc = "Undo Stage Hunk"
        })
        keymap("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", {
            desc = "Reset Hunk"
        })
        keymap("n", "<leader>gg", "<cmd>Gitsigns toggle_signs<cr>", {
            desc = "Toggle Signs"
        })

        -- Telescope
        local ok, builtin = pcall(require, "telescope.builtin")
        if ok then
            keymap("n", "<leader>sh", builtin.help_tags, {
                desc = "[S]earch [H]elp"
            })
            keymap("n", "<leader>sk", builtin.keymaps, {
                desc = "[S]earch [K]eymaps"
            })
            keymap("n", "<leader>sf", builtin.find_files, {
                desc = "[S]earch [F]iles"
            })
            keymap("n", "<leader>ss", builtin.builtin, {
                desc = "[S]earch [S]elect Telescope"
            })
            keymap("n", "<leader>sw", builtin.grep_string, {
                desc = "[S]earch current [W]ord"
            })
            keymap("n", "<leader>sg", builtin.live_grep, {
                desc = "[S]earch by [G]rep"
            })
            keymap("n", "<leader>sd", builtin.diagnostics, {
                desc = "[S]earch [D]iagnostics"
            })
            keymap("n", "<leader>sr", builtin.resume, {
                desc = "[S]earch [R]esume"
            })
            keymap("n", "<leader>s.", builtin.oldfiles, {
                desc = "[S]earch Recent Files"
            })
            keymap("n", "<leader><leader>", builtin.buffers, {
                desc = "Find Buffers"
            })
            keymap("n", "<leader>gs", builtin.git_status, {
                desc = "Git Status"
            })
            keymap("n", "<leader>gl", builtin.git_commits, {
                desc = "Git Log"
            })
            keymap("n", "<leader>gt", builtin.git_stash, {
                desc = "Git Stash"
            })
            keymap("n", "<leader>gb", builtin.git_branches, {
                desc = "Git Branches"
            })

            keymap("n", "<leader>/", function()
                builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
                    winblend = 10,
                    previewer = false
                }))
            end, {
                desc = "Fuzzy Search in Buffer"
            })

            keymap("n", "<leader>s/", function()
                builtin.live_grep({
                    grep_open_files = true,
                    prompt_title = "Live Grep in Open Files"
                })
            end, {
                desc = "[S]earch [/] Open Files"
            })

            keymap("n", "<leader>sn", function()
                builtin.find_files({
                    cwd = vim.fn.stdpath("config")
                })
            end, {
                desc = "[S]earch [N]eovim files"
            })
        end

        -- Leap
        keymap({"n", "x", "o"}, "<leader>f", "<Plug>(leap-forward-to)", {
            desc = "Leap forward"
        })
        keymap({"n", "x", "o"}, "<leader>F", "<Plug>(leap-backward-to)", {
            desc = "Leap backward"
        })
        keymap({"n", "x", "o"}, "<leader>G", "<Plug>(leap-from-window)", {
            desc = "Leap from window"
        })

        -- Trouble
        keymap("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", {
            desc = "Diagnostics (Trouble)"
        })
        keymap("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", {
            desc = "Buffer Diagnostics"
        })
        keymap("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", {
            desc = "Symbols"
        })
        keymap("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", {
            desc = "LSP Locations"
        })
        keymap("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", {
            desc = "Location List"
        })
        keymap("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", {
            desc = "Quickfix List"
        })

        -- Conform
        keymap("n", "<leader>f", function()
            require("conform").format({
                async = true,
                lsp_format = "fallback"
            })
        end, {
            desc = "Format Buffer"
        })

        -- Diffview
        keymap("n", "<leader>gd", "<cmd>DiffviewFileHistory %<cr>", {
            desc = "Diff File History"
        })
        keymap("n", "<leader>gx", "<cmd>DiffviewClose<cr>", {
            desc = "Close Diffview"
        })

        -- CodeCompanion
        keymap({"n", "v"}, "<C-a>", "<cmd>CodeCompanionActions<cr>", {
            noremap = true,
            silent = true
        })
        keymap({"n", "v"}, "<C-c>", "<cmd>CodeCompanion<cr>", {
            noremap = true,
            silent = true
        })
        keymap({"n", "v"}, "<C-t>", "<cmd>CodeCompanionChat Toggle<cr>", {
            noremap = true,
            silent = true
        })
        keymap({"n", "v"}, "<C-d>", "<cmd>CodeCompanionCmd<cr>", {
            noremap = true,
            silent = true
        })
    end
})
