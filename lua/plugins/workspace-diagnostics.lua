return {
	"artemave/workspace-diagnostics.nvim",
	keys = {
		{
			"<C-x>",
			function()
				for _, client in ipairs(vim.lsp.get_clients()) do
					require("workspace-diagnostics").populate_workspace_diagnostics(client, 0)
				end
			end,
			desc = "Populate workspace diagnostics",
		},
	},
}