local overrides = require("custom.configs.overrides")

---@type NvPluginSpec[]
local plugins = {

  -- Override plugin definition options

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- format & linting
      {
        "nvimtools/none-ls.nvim",
        config = function()
          require "custom.configs.null-ls"
        end,
      },
    },
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },

  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = overrides.mason
  },

  {
    "nvim-treesitter/nvim-treesitter",
    -- `master` is frozen and does not support nvim 0.12; `main` is the rewrite.
    -- It has no `nvim-treesitter.configs` module, so highlighting/indent are
    -- wired up here with the core vim.treesitter API instead.
    branch = "main",
    build = ":TSUpdate",
    opts = overrides.treesitter,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "syntax")

      local ts = require "nvim-treesitter"
      ts.setup()

      -- async; no-op for parsers that are already installed
      ts.install(opts.ensure_installed or {})

      local function attach(buf)
        local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
        if not lang then
          return
        end
        local ok, has_parser = pcall(vim.treesitter.language.add, lang)
        if not (ok and has_parser) then
          return
        end
        pcall(vim.treesitter.start, buf, lang)
        if opts.indent and opts.indent.enable then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("NvTreesitterAttach", { clear = true }),
        callback = function(ev)
          attach(ev.buf)
        end,
      })

      -- buffers that were opened before the plugin lazy-loaded
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype ~= "" then
          attach(buf)
        end
      end
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    -- NvChad core pins v2.20.7, which requires nvim-treesitter modules that no
    -- longer exist on the `main` branch ("nvim-treesitter not found" warning).
    -- v3 uses core vim.treesitter directly. Options below mirror the v2 ones in
    -- plugins/configs/others.lua.
    version = "^3.0.0",
    main = "ibl",
    opts = function()
      return {
        indent = { char = "│" },
        scope = { show_start = true, show_end = false },
        exclude = {
          filetypes = {
            "help",
            "terminal",
            "lazy",
            "lspinfo",
            "TelescopePrompt",
            "TelescopeResults",
            "mason",
            "nvdash",
            "nvcheatsheet",
            "",
          },
          buftypes = { "terminal" },
        },
      }
    end,
    config = function(_, opts)
      require("core.utils").load_mappings "blankline"
      dofile(vim.g.base46_cache .. "blankline")

      local hooks = require "ibl.hooks"
      -- reuse the base46 v2 highlight groups
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "IblIndent", { link = "IndentBlanklineChar" })
        vim.api.nvim_set_hl(0, "IblWhitespace", { link = "IndentBlanklineChar" })
        vim.api.nvim_set_hl(0, "IblScope", { link = "IndentBlanklineContextChar" })
      end)
      -- v2 `show_first_indent_level = false`
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)

      require("ibl").setup(opts)
    end,
  },

  -- Install a plugin
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  -- To make a plugin not be loaded
  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   enabled = false
  -- },

  -- All NvChad plugins are lazy-loaded by default
  -- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
  -- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
  -- {
  --   "mg979/vim-visual-multi",
  --   lazy = false,
  -- }
}

return plugins
