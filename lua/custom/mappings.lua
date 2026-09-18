---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
  },
  v = {
    [">"] = { ">gv", "indent"},
  },
}

-- indent-blankline v3 (ibl) replaces the core v2 mapping, which required
-- the removed `indent_blankline.utils` module.
M.blankline = {
  plugin = true,

  n = {
    ["<leader>cc"] = {
      function()
        local ok, scope = pcall(function()
          local bufnr = vim.api.nvim_get_current_buf()
          local config = require("ibl.config").get_config(bufnr)
          return require("ibl.scope").get(bufnr, config)
        end)

        if ok and scope then
          vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { scope:start() + 1, 0 })
          vim.cmd [[normal! _]]
        end
      end,

      "Jump to current context",
    },
  },
}

-- more keybinds!

return M
