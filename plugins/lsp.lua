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
  config = function()
    require('mason').setup()
    require('mason-lspconfig').setup({
      ensure_installed = { 'lua_ls', 'pyright', 'ruff' },
      automatic_enable = true,
    })

    vim.diagnostic.config({
      virtual_text = true,
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    })

    -- 2️⃣ Configure lua_ls
    local lspconfig = require('lspconfig')
    local augroup = vim.api.nvim_create_augroup
    local fmt_group = augroup('LspFormatting', {})


    vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float)

    local on_attach_common = function(client, bufnr)
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

      local map = function(mode, keys, func, desc)
        vim.keymap.set(mode, keys, func, { buffer = bufnr, noremap = true, silent = true, desc = desc })
      end

      map('n', 'gd', vim.lsp.buf.definition, 'Go to definition')
      map('n', 'gD', vim.lsp.buf.declaration, 'Go to declaration')
    end

    lspconfig.lua_ls.setup({
      settings = {
        Lua = {
          formatting = {
            enable = true,
          }
        },
      },
      on_attach = on_attach_common
    })

    lspconfig.pyright.setup({
      on_attach = on_attach_common,
      settings = {
        python = {
          analysis = {
            -- typeCheckingMode = "basic", // "off", "basic", or "strict"
            -- useLibraryCodeForTypes = true,
            -- autoSearchPaths = true,
            -- diagnosticMode = "workspace", // analyze all files in workspace
          }
        }
      },
    })

    lspconfig.ruff.setup({
      on_attach = on_attach_common,
      init_options = {
        settings = {
          -- args = {}, -- You can pass command line arguments to ruff here if needed
          -- To enable ruff as a formatter (it needs to be configured in your ruff.toml for this to be effective):
          -- format = { args = {} } -- This signals to ruff_lsp to offer formatting
          -- Enable linting (default)
          lint = { args = {} },
        }
      }
    })
  end,
}
