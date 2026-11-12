return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	opts = {
		lsp = {
			progress = {
				enabled = false,
			},
			-- Override markdown rendering so LSP docs use Treesitter.
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
			},
		},
		presets = {
			bottom_search = true, -- classic bottom cmdline for search
			command_palette = true, -- position the cmdline and popupmenu together
			long_message_to_split = true, -- long messages go to a split
			inc_rename = false, -- input dialog for inc-rename.nvim
			lsp_doc_border = false, -- border for hover docs and signature help
		},
	},
}