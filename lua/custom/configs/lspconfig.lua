-- on_attach and capabilities are applied to every server via
-- vim.lsp.config("*", ...) in plugins.configs.lspconfig.
require "plugins.configs.lspconfig"

-- Servers to enable with nvim-lspconfig's default config (lsp/<name>.lua).
-- To customise one: vim.lsp.config("pyright", { settings = { ... } })
local servers = { "html", "cssls", "ts_ls", "clangd" }

vim.lsp.enable(servers)
