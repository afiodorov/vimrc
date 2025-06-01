return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
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
  opts = {
    diagnostics = {
      virtual_text = true,
    },
  },
  config = function()
    -- 1️⃣ Install mason + mason-lspconfig
    require('mason').setup()
    require('mason-lspconfig').setup({
      ensure_installed = { 'lua_ls' },
      automatic_enable = true,
    })

    -- 2️⃣ Configure lua_ls
    local lspconfig = require('lspconfig')
    local augroup = vim.api.nvim_create_augroup
    local fmt_group = augroup('LspFormatting', {})

    lspconfig.lua_ls.setup({
      settings = {
        Lua = {
          formatting = {
            enable = true,
            -- you can add more stylua-style options here if you like
          }
        }
      },
      on_attach = function(client, bufnr)
        -- only if the server supports formatting
        if client.server_capabilities.documentFormattingProvider then
          -- clear any existing formatting autocmds on this buffer
          vim.api.nvim_clear_autocmds({ group = fmt_group, buffer = bufnr })
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = fmt_group,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ bufnr = bufnr, async = false })
            end,
          })
        end


        vim.api.nvim_create_autocmd('CursorHold', {
          buffer = bufnr,
          callback = function()
            vim.diagnostic.open_float(nil, {
              focusable = false, -- Don't focus the float window
              scope = "cursor" -- Show diagnostics for the cursor position
            })
          end
        })
      end,
    })
  end,
}
