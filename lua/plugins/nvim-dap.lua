--[[ ---------------------------------------------------------------------
  nvim-dap - Debug Adapter Protocol client (debugger)
  Repo: mfussenegger/nvim-dap (+ rcarriga/nvim-dap-ui)

  WHAT IT IS
    A debugger inside Neovim. nvim-dap speaks the Debug Adapter
    Protocol, the same protocol VS Code uses, so the same adapters
    (netcoredbg, js-debug-adapter, debugpy) give you breakpoints,
    stepping, call stacks, scopes and a REPL in the editor.
    nvim-dap-ui draws the sidebar / panel layout around the session
    and nvim-dap-virtual-text shows variable values inline.

  WHY IT IS USEFUL
    - Debug .NET, Node / TS and Python without switching to an IDE.
    - Conditional breakpoints and step in / over / out from the
      same keys in every language.
    - The UI opens and closes automatically with the session, and
      variable values appear next to the code while stepping.

  HOW IT IS CONFIGURED HERE
    - Dependencies: rcarriga/nvim-dap-ui, nvim-neotest/nvim-nio,
      mason-org/mason.nvim, theHamsta/nvim-dap-virtual-text.
      Adapters are the Mason-installed binaries under
      stdpath('data')/mason/bin (installed via nvim-lspconfig.lua).
    - require('dapui').setup() and nvim-dap-virtual-text.setup({})
      both use defaults.
    - .NET: adapter 'coreclr' = executable netcoredbg with
      '--interpreter=vscode'. Configuration for filetype cs:
      'launch - netcoredbg' prompts 'Path to dll: ' pre-filled
      with getcwd() .. '/bin/Debug/'.
    - JS/TS: adapter 'pwa-node' = server on localhost, port ${port},
      executable js-debug-adapter. Configurations are created in a
      loop for typescript and javascript: 'Launch file' (${file},
      cwd ${workspaceFolder}) and 'Attach' (processId picked with
      require('dap.utils').pick_process).
    - Python: adapter is a function - for 'attach' it returns a
      server adapter using config.connect.port (asserted, required)
      and host (default 127.0.0.1); otherwise an executable
      debugpy-adapter. Configuration 'Launch file' (${file}) with
      pythonPath() preferring ./venv/bin/python, then
      ./.venv/bin/python, then plain 'python'.
    - Listeners: dapui.open() on before.attach and before.launch,
      dapui.close() on before.event_terminated and event_exited.

  HOW TO INVOKE IT
    - <Leader>b  - dap.toggle_breakpoint on the current line.
    - <Leader>B  - conditional breakpoint, prompts for a condition.
    - <F5>       - dap.continue (start / resume; picks a config).
    - <F10> / <F11> / <F12> - step over / step into / step out.
    - <Leader>du - dapui.toggle the debug UI manually.
    - Inside a session: use the dap-ui windows for stack, scopes,
      watches and breakpoints, and the DAP REPL buffer to evaluate
      expressions. :DapContinue, :DapTerminate and friends also work.

  FEATURES
    - Launch and attach for C#, JS/TS (Node) and Python.
    - Breakpoints, conditional breakpoints, stepping and continue.
    - Auto-opening UI with stacks, scopes, watches and console.
    - Inline virtual text of variable values while stopped.
    - Mason-managed adapters, so no paths outside stdpath data.
---------------------------------------------------------------------]]


return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"mason-org/mason.nvim",
		"theHamsta/nvim-dap-virtual-text",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		require("dapui").setup()
		require("nvim-dap-virtual-text").setup({})

		-- .NET Configuration
		dap.adapters.coreclr = {
			type = "executable",
			command = vim.fn.stdpath("data") .. "/mason/bin/netcoredbg",
			args = { "--interpreter=vscode" },
		}

		dap.configurations.cs = {
			{
				type = "coreclr",
				name = "launch - netcoredbg",
				request = "launch",
				program = function()
					return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
				end,
			},
		}

		-- JS/TS Configuration
		dap.adapters["pwa-node"] = {
			type = "server",
			host = "localhost",
			port = "${port}",
			executable = {
				command = vim.fn.stdpath("data") .. "/mason/bin/js-debug-adapter",
				args = { "${port}" },
			},
		}

		for _, language in ipairs({ "typescript", "javascript" }) do
			dap.configurations[language] = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					cwd = "${workspaceFolder}",
				},
				{
					type = "pwa-node",
					request = "attach",
					name = "Attach",
					processId = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}",
				},
			}
		end

		-- Python Configuration
		dap.adapters.python = function(cb, config)
			if config.request == "attach" then
				---@diagnostic disable-next-line: undefined-field
				local port = (config.connect or config).port
				---@diagnostic disable-next-line: undefined-field
				local host = (config.connect or config).host or "127.0.0.1"
				cb({
					type = "server",
					port = assert(port, "`connect.port` is required for a python `attach` configuration"),
					host = host,
					options = {
						source_filetype = "python",
					},
				})
			else
				cb({
					type = "executable",
					command = vim.fn.stdpath("data") .. "/mason/bin/debugpy-adapter",
					options = {
						source_filetype = "python",
					},
				})
			end
		end

		dap.configurations.python = {
			{
				type = "python",
				request = "launch",
				name = "Launch file",
				program = "${file}",
				pythonPath = function()
					local cwd = vim.fn.getcwd()
					if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
						return cwd .. "/venv/bin/python"
					elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
						return cwd .. "/.venv/bin/python"
					else
						return "python"
					end
				end,
			},
		}

		-- Listeners to auto-open UI
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		-- Keymaps
		vim.keymap.set("n", "<Leader>b", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
		vim.keymap.set("n", "<Leader>B", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, { desc = "Set Conditional Breakpoint" })
		vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Continue" })
		vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
		vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
		vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })
		vim.keymap.set("n", "<Leader>du", dapui.toggle, { desc = "Toggle Debug UI" })
	end,
}
