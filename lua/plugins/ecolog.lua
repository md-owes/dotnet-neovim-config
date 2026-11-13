--[[ ---------------------------------------------------------------------
  ecolog.nvim - environment (.env) file integration
  Repo: ph1losof/ecolog.nvim

  WHAT IT IS
    A plugin for working with .env files. It finds .env files in your
    project, lets you jump from an env-var usage in code to its definition
    in the .env file, peek at a variable's value without opening the file,
    switch between env files (development, production, ...), and complete
    env-var names in code through blink.cmp.

  WHY IT IS USEFUL
    - Env vars are invisible by default: this makes them navigable like
      normal code - go to definition, peek value, switch file.
    - Completion means you never have to remember exact variable names
      or open the .env file to check spelling.
    - Switching env files per context avoids editing the wrong file.
    - Built-in type detection (database_url, url and others) helps
      validate values and improves completion behaviour.

  HOW IT IS CONFIGURED HERE
    - lazy = false: lazy loading is handled internally by the plugin.
    - integrations.blink_cmp = true, integrations.nvim_cmp = false:
      completion goes through blink.cmp (see lua/plugins/blink.lua,
      where the 'ecolog' source has score_offset 50).
    - types = true: built-in types (database_url, url, etc.) are enabled.
    - path = vim.fn.getcwd(): .env files are searched from the current
      working directory.
    - preferred_environment = 'development': development env files are
      prioritised when several match.
    - provider_patterns = true: provider patterns are checked when
      extracting env vars from code and driving completion.
    - Keymaps (normal mode):
        <leader>veg - Go to env file: :EcologGoto
        <leader>vep - Ecolog peek variable: :EcologPeek
        <leader>ves - Switch env file: :EcologSelect

  HOW TO INVOKE IT
    - Put the cursor on an env var (for example process.env.DATABASE_URL
      or os.getenv('API_KEY')) and press <leader>veg to jump to its line
      in the .env file, or <leader>vep to peek at its value in a float.
    - <leader>ves opens a picker to switch the active env file.
    - Start typing an env-var name in code to get completions from the
      ecolog blink.cmp source.
    - Commands: :EcologGoto, :EcologPeek, :EcologSelect (and related
      :Ecolog* commands - complete with :Ecolog<Tab> to list them).

  FEATURES
    - Go to definition in .env files from code references.
    - Peek at a variable value without leaving the buffer.
    - Switch between multiple env files in one project.
    - blink.cmp completion of variable names, with provider-pattern
      aware extraction from code.
    - Type detection for common variable kinds (URLs, database URLs...).
    - Optional lspsaga / LSP integrations for a smoother experience
      without separate keybindings (not enabled here).
---------------------------------------------------------------------]]


return {
	"ph1losof/ecolog.nvim",
	-- Optional: you can add some keybindings
	-- (I personally use lspsaga so check out lspsaga integration or lsp integration for a smoother experience without separate keybindings)
	keys = {
		{ "<leader>veg", "<cmd>EcologGoto<cr>", desc = "Go to env file" },
		{ "<leader>vep", "<cmd>EcologPeek<cr>", desc = "Ecolog peek variable" },
		{ "<leader>ves", "<cmd>EcologSelect<cr>", desc = "Switch env file" },
	},
	-- Lazy loading is done internally
	lazy = false,
	opts = {
		integrations = {
			-- WARNING: for both cmp integrations see readme section below
			nvim_cmp = false, -- If you dont plan to use nvim_cmp set to false, enabled by default
			-- If you are planning to use blink cmp uncomment this line
			blink_cmp = true,
		},
		-- true by default, enables built-in types (database_url, url, etc.)
		types = true,
		path = vim.fn.getcwd(), -- Path to search for .env files
		preferred_environment = "development", -- Optional: prioritize specific env files
		-- Controls how environment variables are extracted from code and how cmp works
		provider_patterns = true, -- true by default, when false will not check provider patterns
	},
}
