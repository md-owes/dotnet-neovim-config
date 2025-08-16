return {
    "yetone/avante.nvim",
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    -- ⚠️ must add this setting! ! !
    build = vim.fn.has("win32") ~= 0
        and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
        or "make",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    ---@module 'avante'
    ---@type avante.Config
    opts = {
        -- Basic provider configuration (valid options only)
        provider = "openrouterv1",

        providers = {
            openrouterv1 = {
                __inherited_from = "openai",
                endpoint = "https://openrouter.ai/api/v1",
                api_key_name = "OPENROUTERV1_API_KEY",
                model = "qwen/qwen3-coder:free",
            },
            openrouterv2 = {
                __inherited_from = "openai",
                endpoint = "https://openrouter.ai/api/v1",
                api_key_name = "OPENROUTERV2_API_KEY",
                model = "moonshotai/kimi-k2:free",
            },
            openrouterv3 = {
                __inherited_from = "openai",
                endpoint = "https://openrouter.ai/api/v1",
                api_key_name = "OPENROUTERV3_API_KEY",
                model = "deepseek/deepseek-r1-0528:free",
                disable_tools = true,
            },
        },

        -- Productivity shortcuts with comprehensive AI tasks
        shortcuts = {
            {
                name = "refactor",
                description = "🔧 Refactor code with best practices",
                details =
                "Automatically refactor code to improve readability, maintainability, and follow best practices while preserving functionality",
                prompt =
                "Please refactor this code following best practices, improving readability and maintainability while preserving functionality."
            },
            {
                name = "test",
                description = "🧪 Generate comprehensive unit tests",
                details =
                "Create comprehensive unit tests covering edge cases, error scenarios, and various input conditions",
                prompt =
                "Please generate comprehensive unit tests for this code, covering edge cases and error scenarios. Include setup, teardown, mocking where necessary."
            },
            {
                name = "optimize",
                description = "⚡ Optimize performance and efficiency",
                details = "Improve code performance, reduce complexity, and optimize algorithms",
                prompt =
                "Please optimize this code for better performance, considering time and space complexity. Suggest algorithmic improvements and identify bottlenecks."
            },
            {
                name = "document",
                description = "📚 Add comprehensive documentation",
                details = "Generate thorough documentation including docstrings, comments, and usage examples",
                prompt =
                "Please add comprehensive documentation to this code, including detailed docstrings, inline comments explaining complex logic, and usage examples."
            },
            {
                name = "debug",
                description = "🐛 Debug and fix issues",
                details = "Identify bugs, potential issues, and suggest fixes with explanations",
                prompt =
                "Please analyze this code for potential bugs, edge cases, or issues. Suggest fixes with detailed explanations of what could go wrong."
            },
            {
                name = "explain",
                description = "💡 Explain code functionality",
                details = "Provide detailed explanation of how code works, including algorithms and design patterns",
                prompt =
                "Please explain how this code works in detail, including the algorithms used, design patterns, and the reasoning behind implementation choices."
            },
            {
                name = "security",
                description = "🔒 Security audit and improvements",
                details = "Check for security vulnerabilities and suggest secure coding practices",
                prompt =
                "Please audit this code for security vulnerabilities, including input validation, authentication, authorization, and other security concerns. Suggest improvements."
            },
            {
                name = "review",
                description = "👀 Code review and suggestions",
                details = "Comprehensive code review with improvement suggestions",
                prompt =
                "Please perform a comprehensive code review, checking for code quality, maintainability, performance, security, and adherence to best practices."
            },
            {
                name = "convert",
                description = "🔄 Convert between languages/frameworks",
                details = "Convert code to different programming languages or frameworks",
                prompt =
                "Please convert this code to [specify target language/framework], maintaining the same functionality and following the target's best practices."
            },
            {
                name = "modernize",
                description = "🆕 Modernize legacy code",
                details = "Update old code to use modern language features and patterns",
                prompt =
                "Please modernize this code using current language features, design patterns, and best practices while maintaining backward compatibility where needed."
            },
        },

        -- Enhanced window configuration
        windows = {
            position = "right",
            width = 40,
            wrap = true,
            sidebar_header = {
                enabled = true,
                align = "center",
                rounded = true,
            },
        },

    },

    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-telescope/telescope.nvim",
        "hrsh7th/nvim-cmp",
        "folke/snacks.nvim",
        "nvim-tree/nvim-web-devicons",
    },
}
