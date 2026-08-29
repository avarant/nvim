# nvim

My Neovim config: [NvChad v2.0](https://github.com/NvChad/NvChad/tree/v2.0) base with customizations in `lua/custom/`.

- Theme: onedark (toggle to one_light)
- LSP: html, cssls, tsserver, clangd (via mason + nvim-lspconfig)
- Formatting: null-ls (deno_fmt, prettier, stylua, clang-format)
- Extras: better-escape, nvim-tree git status, treesitter for lua/web/c/markdown
- `;` enters command mode in normal mode; `>` in visual mode re-selects after indent
- `cheatsheet.html` — keybinding reference (open in a browser)

Plugin versions are pinned in `lazy-lock.json`.

## Install

Requires Neovim >= 0.9, git, a C compiler (for treesitter), and a [Nerd Font](https://www.nerdfonts.com/).

```bash
# back up / remove any existing config and plugin state
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null
rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim

git clone https://github.com/avarant/nvim.git ~/.config/nvim
nvim   # first launch bootstraps lazy.nvim and installs all plugins
```

Then run `:MasonInstallAll` inside nvim to install the LSP servers and formatters.

## Structure

```
init.lua              # NvChad entry point
lua/core/             # NvChad core (options, mappings, bootstrap)
lua/plugins/          # NvChad default plugin specs
lua/custom/           # my overrides — this is the part I edit
  chadrc.lua          #   theme + wiring
  plugins.lua         #   extra plugins / plugin overrides
  mappings.lua        #   keymaps
  highlights.lua      #   highlight tweaks
  configs/            #   lspconfig, null-ls, mason/treesitter/nvim-tree overrides
```

Licensed GPL-3.0 (inherited from NvChad) — see `LICENSE`.
