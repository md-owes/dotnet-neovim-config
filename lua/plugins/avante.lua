return {
	"avante-corp/avante.nvim",
	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	-- ⚠️ must add this setting! ! !
	build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
		or "make",
	event = "VeryLazy",
	version = false, -- Never set this value to "*"! Never!
	---@module 'avante'
	opts = {
		-- Basic provider configuration (valid options only)
		provider = "positionapi",

		providers = {
			positionapi = {
				__inherited_from = "openai",
				endpoint = "https://positionapi.top/v1",
				api_key_name = "POSITION_API_KEY",
				model = "gpt-6-astra",
								use_response_api = true,
								support_previous_response_id = false,
								extra_request_body = {
									store = false, -- Stateless Responses: full history goes in input, nothing is stored server-side
								},
			},
		},

		-- Recommended settings
		selection = {
			hint_display = "delayed",
		},

		-- Enhanced window configuration
		windows = {
			position = "right",
			width = 40,
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
		{ "ColinKennedy/mega.cmdparse", dependencies = { "ColinKennedy/mega.logging" } },
	},
}
