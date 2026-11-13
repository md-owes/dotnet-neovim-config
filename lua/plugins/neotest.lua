--[[ ---------------------------------------------------------------------
  neotest - unified test runner framework
  Repo: nvim-neotest/neotest

  WHAT IT IS
    A framework for running tests from inside Neovim and seeing the
    results in place: pass / fail signs in the sign column, inline
    output, a summary tree of suites and cases, and a panel for full
    output. Neotest itself knows no test runners - adapters plug in
    per ecosystem, discover the tests and report results back.

  WHY IT IS USEFUL
    - Run the nearest test, a whole file or a suite without leaving
      the editor or remembering each runner's CLI flags.
    - Failures are shown where the test lives, with output one
      keypress away, instead of buried in terminal scrollback.
    - Same keymaps and UI for .NET and JS/TS projects in this config.

  HOW IT IS CONFIGURED HERE
    - config() calls require('neotest').setup({ adapters = {...} })
      with exactly two adapters:
        require('neotest-dotnet')  - .NET (xUnit / NUnit / MSTest)
        require('neotest-vitest')  - Vitest for JS/TS projects
    - Dependencies: nvim-neotest/nvim-nio (async), plenary.nvim,
      nvim-treesitter (test discovery parses the buffer), plus the
      two adapter plugins issafalcon/neotest-dotnet and
      marilari88/neotest-vitest.
    - No other opts are set, so discovery, signs, summary window
      layout and output behaviour are all Neotest defaults.
    - The '<leader>t' prefix itself is a group stub with desc
      '+test', so which-key shows it as a group (see which-key.lua).

  HOW TO INVOKE IT
    - <leader>tt - Run File: run.run(vim.fn.expand('%'))
    - <leader>tr - Run Nearest: run.run() for the test at the cursor
    - <leader>ts - Toggle Summary: summary tree of suites / results
    - <leader>to - Show Output: output.open({ enter = true,
                   auto_close = true }) for the test at the cursor
    - <leader>tO - Toggle Output Panel: all output in a bottom panel
    - <leader>tS - Stop: run.stop() the running test process
    - In the summary window, expand a suite with <CR> / Tab and use
      its local keys to run, attach to or watch tests (':h neotest').

  FEATURES
    - Per-adapter discovery: dotnet test projects and Vitest specs
      appear as a navigable tree of namespaces, suites and cases.
    - Run nearest / file / suite, stop a run, re-run from the summary.
    - Inline diagnostic-style failures and virtual text results.
    - Summary sidebar, floating output and persistent output panel.
    - Watch mode and DAP integration exist in Neotest itself but
      are not bound to keys in this config.
---------------------------------------------------------------------]]


return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		-- Adapters
		"issafalcon/neotest-dotnet",
		"marilari88/neotest-vitest",
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-dotnet"),
				require("neotest-vitest"),
			},
		})
	end,
	keys = {
		{ "<leader>t", "", desc = "+test" },
		{
			"<leader>tt",
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			desc = "Run File",
		},
		{
			"<leader>tr",
			function()
				require("neotest").run.run()
			end,
			desc = "Run Nearest",
		},
		{
			"<leader>ts",
			function()
				require("neotest").summary.toggle()
			end,
			desc = "Toggle Summary",
		},
		{
			"<leader>to",
			function()
				require("neotest").output.open({ enter = true, auto_close = true })
			end,
			desc = "Show Output",
		},
		{
			"<leader>tO",
			function()
				require("neotest").output_panel.toggle()
			end,
			desc = "Toggle Output Panel",
		},
		{
			"<leader>tS",
			function()
				require("neotest").run.stop()
			end,
			desc = "Stop",
		},
	},
}
