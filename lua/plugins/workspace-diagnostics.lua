--[[ ---------------------------------------------------------------------
  workspace-diagnostics.nvim - publish LSP diagnostics for the whole workspace
  Repo: artemave/workspace-diagnostics.nvim

  WHAT IT IS
    Language servers normally only report diagnostics for files you
    have open. This plugin asks every attached server to publish
    diagnostics for the entire workspace - all project files - so
    the diagnostics list is complete even for files you have never
    opened. It is the bridge between the per-buffer diagnostics
    configured in lua/plugins/nvim-lspconfig.lua and a project-wide
    view in Trouble (see lua/plugins/trouble.lua): without it,
    :Trouble diagnostics would only show errors from open buffers.

  WHY IT IS USEFUL
    - Find every error in the project before a commit or a review,
      not just the ones in the files you happened to open.
    - Works with any language server already attached - no
      per-server configuration is needed.
    - One keypress refreshes the whole workspace view after a
      large change, a branch switch or a generated-code update.

  HOW IT IS CONFIGURED HERE
    - No opts and no config() are set; the whole spec is the
      plugin name plus one keymap.
    - Keymap (normal mode):
        <C-x> - Populate workspace diagnostics: for each client
                in vim.lsp.get_clients(), calls
                require('workspace-diagnostics')
                  .populate_workspace_diagnostics(client, 0)
                (the 0 argument targets the current workspace).
    - It is lazy-loaded on that keymap: the plugin is not loaded
      until <C-x> is pressed for the first time.

  HOW TO INVOKE IT
    - Press <C-x> in normal mode, then open the diagnostics view
      (<leader>xx for Trouble diagnostics) to see the populated
      list for the whole workspace.
    - The same call can be run from the command line with
      :lua for _, client in ipairs(vim.lsp.get_clients()) do
        require('workspace-diagnostics')
          .populate_workspace_diagnostics(client, 0) end
    - Populating can take a moment on a large workspace, since
      each server has to analyse files it has not seen yet.

  FEATURES
    - Workspace-wide diagnostic publishing for all attached LSP
      clients at once.
    - No server-specific setup: it drives the standard LSP
      diagnostic request for each client.
    - Pairs with Trouble's workspace diagnostics view and with
      the diagnostic signs / virtual text from nvim-lspconfig.
---------------------------------------------------------------------]]


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
