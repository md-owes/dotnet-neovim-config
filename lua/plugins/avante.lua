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

        -- Recommended settings
        hints = { enabled = true },
        autobutton = { enabled = true },

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
        "folke/snacks.nvim",
    },
}
