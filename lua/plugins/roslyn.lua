return {
    "seblyng/roslyn.nvim",
    ft = { "cs" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        -- roslyn.nvim setup() only accepts filewatching / target options.
        -- Server settings and capabilities must go through vim.lsp.config("roslyn").
        -- Mason installs the server as `roslyn`, but roslyn.nvim looks for
        -- `roslyn-language-server` in Mason's bin dir and falls back to that
        -- unresolvable name, so the client never starts. Point it at the
        -- actual Mason binary explicitly.
        local roslyn_bin = vim.fn.stdpath("data") .. "/mason/bin/roslyn"
        vim.lsp.config("roslyn", {
            -- NOTE: No --daemon-mode here: the Mason build is 5.8.0, and
            -- daemon mode was only added in 5.12. Passing it makes the
            -- server exit with "Unrecognized command or argument".
            cmd = {
                roslyn_bin,
                "--stdio",
                "--clientProcessId",
                tostring(vim.uv.os_getpid()),
                "--extensionLogDirectory",
                vim.fs.joinpath(vim.fn.stdpath("log"), "roslyn"),
            },
            capabilities = require("blink.cmp").get_lsp_capabilities(),
            settings = {
                ["csharp|code_lens"] = {
                    dotnet_enable_references_code_lens = true,
                    dotnet_enable_tests_code_lens = true,
                },
                ["csharp|background_analysis"] = {
                    dotnet_analyzer_diagnostics_scope = "fullSolution",
                    dotnet_compiler_diagnostics_scope = "fullSolution",
                },
                ["csharp|completion"] = {
                    dotnet_provide_regex_completions = true,
                    dotnet_show_completion_items_from_unimported_namespaces = true,
                    dotnet_show_name_completion_suggestions = true,
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
                    dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
                },
                ["csharp|symbol_search"] = {
                    dotnet_search_reference_assemblies = true,
                },
                ["csharp|formatting"] = {
                    dotnet_organize_imports_on_format = true,
                },
                ["csharp|quick_info"] = {
                    dotnet_show_remarks_in_quick_info = true,
                },
                ["csharp|highlighting"] = {
                    dotnet_highlight_related_regex_components = true,
                    dotnet_highlight_related_json_components = true,
                },
                ["csharp|code_style.formatting.indentation_and_spacing"] = {
                    tab_width = true,
                    indent_size = true,
                    indent_style = true,
                },
                ["csharp|code_style.formatting.new_line"] = {
                    end_of_line = true,
                },
                ["code_style.formatting.new_line"] = {
                    insert_final_newline = true,
                },
                ["navigation"] = {
                    dotnet_navigate_to_decompiled_sources = true,
                },
            },
        })
        require("roslyn").setup({})
        vim.lsp.enable("roslyn")
    end,
}
