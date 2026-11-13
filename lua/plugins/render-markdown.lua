--[[ ---------------------------------------------------------------------
  render-markdown.nvim - render Markdown beautifully inside the buffer
  Repo: MeanderingProgrammer/render-markdown.nvim

  WHAT IT IS
    Turns raw Markdown source into a readable rendered view without
    leaving Neovim or opening a preview: headings get icons and
    background highlights, checkboxes become clickable-looking boxes,
    code blocks get a language label and border, tables, lists,
    quotes, links and callouts are all drawn in place. The text
    itself is unchanged - only how it is displayed changes.

  WHY IT IS USEFUL
    - Read READMEs, notes and documentation comfortably in the editor.
    - Checkboxes and headings are scannable at a glance instead of
      a wall of '#' and '- [ ]' markers.
    - It also renders the Avante AI chat sidebar (filetype 'Avante'),
      so AI answers with Markdown formatting are readable there too.
    - No external preview server or browser is needed.

  HOW IT IS CONFIGURED HERE
    - ft = { 'markdown', 'Avante' }: the plugin only loads for
      Markdown buffers and the Avante chat buffer.
    - opts.file_types = { 'markdown', 'Avante' }: rendering is
      enabled for exactly those two filetypes.
    - Dependencies: nvim-treesitter/nvim-treesitter (parsing) and
      echasnovski/mini.nvim (icons - see lua/plugins/mini.lua).
    - No other opts are set, so all rendering defaults apply for
      headings, bullets, checkboxes, code blocks and tables.
    - The commented dependency lines show the alternatives if the
      mini.nvim suite were replaced by standalone mini.icons or by
      nvim-web-devicons.

  HOW TO INVOKE IT
    - Automatic: open a .md file (or the Avante sidebar) and the
      Markdown is rendered in place.
    - :RenderMarkdown toggle - toggle rendering in the current buffer.
    - :RenderMarkdown enable / :RenderMarkdown disable - turn it on
      or off explicitly for the buffer.
    - Editing still works normally: the cursor line shows the raw
      Markdown source while the rest stays rendered.

  FEATURES
    - Rendered headings, bullets, numbered lists and checkboxes.
    - Fenced code blocks with language labels and highlighting.
    - Tables, block quotes, horizontal rules and links.
    - Callouts and anti-conceal behaviour on the cursor line.
    - Avante chat rendering via the 'Avante' filetype.
---------------------------------------------------------------------]]


return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
	-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' },      -- if you use standalone mini plugins
	-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
	---@module 'render-markdown'
	ft = { "markdown", "Avante" },
	opts = {
		file_types = { "markdown", "Avante" },
	},
}
