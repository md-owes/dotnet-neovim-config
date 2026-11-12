# dotnet-neovim-config

A modular Neovim configuration tuned for .NET developers, with first-class
support for Astro and React/TypeScript frontends.

## Requirements

- Neovim **0.11+** (tested on 0.12)
- A [Nerd Font](https://www.nerdfonts.com/) (e.g. JetBrainsMono Nerd Font)
- `git` and `ripgrep` for pickers and source control
- A C compiler for building Treesitter parsers

`lazy.nvim` bootstraps itself on first startup; no separate package manager
installation is required.

## Structure

```
init.lua                 Entry point
lua/
  core/
    options.lua          Editor options and providers
    keymaps.lua          Global keybindings
    autocommands.lua     Autocommands and custom commands
    lazy.lua             lazy.nvim bootstrap + setup
  plugins/               One file per plugin
```

## Key plugins

| Area        | Plugin |
| ----------- | ------ |
| Completion  | blink.cmp |
| LSP         | nvim-lspconfig + mason, roslyn.nvim (C#), rustaceanvim (Rust) |
| Formatting  | conform.nvim |
| Debugging   | nvim-dap + nvim-dap-ui |
| Testing     | neotest |
| AI          | Avante (PositionAPI), Supermaven |
| UI          | tokyonight, lualine, snacks.nvim, noice, trouble, which-key |
| Editing     | mini.nvim, gitsigns, leap, grug-far, vim-sleuth |

## Notes

- `<space>` is the leader key. Use `<leader>s` for search/pickers and
  `<leader>x` for diagnostics.
- Some AI plugins require API keys configured as environment variables, for
  example `POSITION_API_KEY` for the Avante PositionAPI provider.
- Keep `lazy-lock.json` committed for reproducible plugin versions and run
  `:Lazy sync` after pulling changes.