-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })

-- ---------------------------------------------------------------------------
-- Compatibility shims for NvChad v2.0 `ui` (unmaintained, pinned in lazy-lock).
-- It still calls APIs that Neovim 0.11+ marks deprecated and warns about on
-- every LSP attach / statusline redraw. Provide non-warning equivalents.
-- Remove once `ui` is replaced/updated.
-- ---------------------------------------------------------------------------
if vim.fn.has "nvim-0.11" == 1 then
  -- ui/lua/nvchad/statusline/*.lua and nvchad/signature.lua
  vim.lsp.get_active_clients = vim.lsp.get_clients

  -- ui/lua/nvchad/lsp.lua and nvchad/signature.lua
  vim.lsp.with = function(handler, override_config)
    return function(err, result, ctx, config)
      return handler(err, result, ctx, vim.tbl_deep_extend("force", config or {}, override_config))
    end
  end

  -- nvchad/lsp.lua used vim.lsp.with on the hover / signatureHelp handlers to
  -- add borders; vim.lsp.buf.* no longer consults those handlers, so apply the
  -- same borders here instead.
  local hover, signature_help = vim.lsp.buf.hover, vim.lsp.buf.signature_help
  vim.lsp.buf.hover = function(opts)
    return hover(vim.tbl_deep_extend("force", { border = "single" }, opts or {}))
  end
  vim.lsp.buf.signature_help = function(opts)
    return signature_help(vim.tbl_deep_extend("force", { border = "single", focusable = false }, opts or {}))
  end
end
