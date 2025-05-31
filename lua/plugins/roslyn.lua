return {
    "seblyng/roslyn.nvim",
    ft = {"cs"}, -- Specify filetypes to activate the plugin for C# and VB.NET
    opts = {
        ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
            dotnet_enable_tests_code_lens = true
        },
        ["csharp|background_analysis"] = {
            dotnet_analyzer_diagnostics_scope = "fullSolution",
            dotnet_compiler_diagnostics_scope = "fullSolution"
        },
        ["csharp|completion"] = {
            dotnet_provide_regex_completions = true,
            dotnet_show_completion_items_from_unimported_namespaces = true,
            dotnet_show_name_completion_suggestions = true
        },
        ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true
        },
        ["csharp|symbol_search"] = {
            dotnet_search_reference_assemblies = true
        },
        ["csharp|formatting"] = {
            dotnet_organize_imports_on_format = true
        },
        ["csharp|quick_info"] = {
            dotnet_show_remarks_in_quick_info = true
        },
        ["csharp|highlighting"] = {
            dotnet_highlight_related_regex_components = true,
            dotnet_highlight_related_json_components = true
        },
        ["csharp|code_style.formatting.indentation_and_spacing"] = {
            tab_width = true,
            indent_size = true,
            indent_style = true
        },
        ["csharp|code_style.formatting.new_line"] = {
            end_of_line = true
        },
        ["code_style.formatting.new_line"] = {
            insert_final_newline = true
        },
        ["navigation"] = {
            dotnet_navigate_to_decompiled_sources = true
        }
    },
    -- config = {function(_, opts)
    --     require("roslyn").setup(opts)

    --     -- Optional: Setup keymaps for LSP features after roslyn is configured
    --     -- This is usually handled by your global LSP keymap setup (from Kickstart)
    --     -- but you can add roslyn-specific ones if needed.
    --     -- Example: vim.keymap.set("n", "<leader>lR", "<cmd>RoslynRestart<CR>", { desc = "Restart Roslyn" })
    -- end},
    dependencies = {"nvim-lua/plenary.nvim", -- Often a common dependency
    "nvim-telescope/telescope.nvim" -- For commands like :Roslyn target
    -- Mason is implicitly a dependency if you use it to install the server
    }
}
