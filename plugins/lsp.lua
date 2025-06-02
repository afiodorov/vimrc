return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'saghen/blink.cmp',
    {
      "folke/lazydev.nvim",
      ft = "lua", -- only load on lua files
      opts = {
        library = {
          -- Or relative, which means they will be resolved from the plugin dir.
          "lazy.nvim",
          -- It can also be a table with trigger words / mods
          -- Only load luvit types when the `vim.uv` word is found
          { path = "${3rd}/luv/library",        words = { "vim%.uv" } },
          vim.env.VIMRUNTIME,
          -- always load the LazyVim library
          "LazyVim",
          -- Only load the lazyvim library when the `LazyVim` global is found
          { path = "LazyVim",                   words = { "LazyVim" } },
          -- Load the wezterm types when the `wezterm` module is required
          -- Needs `justinsgithub/wezterm-types` to be installed
          { path = "wezterm-types",             mods = { "wezterm" } },
          -- Load the xmake types when opening file named `xmake.lua`
          -- Needs `LelouchHe/xmake-luals-addon` to be installed
          { path = "xmake-luals-addon/library", files = { "xmake.lua" } },
        },
        enabled = function(root_dir)
          local _ = root_dir
          return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
        end,
      },
    },
  },
  config = function()
    require('mason').setup()
    require('mason-lspconfig').setup({
      ensure_installed = { 'lua_ls', 'pyright', 'ruff' },
      automatic_enable = true,
    })

    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          local msg = diagnostic.message:gsub("\n", " ") -- single‐line
          local src = diagnostic.source or "unknown"
          return string.format("%s [%s]", msg, src)
        end,
      },
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    })

    vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration)
  end,
}
