-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', opt = true }, -- Optional: for file icons
    config = function()
      require('lualine').setup {
        options = {
          theme = 'auto', -- Or your preferred theme (e.g., 'tokyonight', 'onedark', etc.)
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          icons_enabled = true, -- Set to false if you don't have/want nvim-web-devicons
          always_divide_middle = true,
          globalstatus = false, -- Set to true if you want the statusline to be global
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = {
            {
              'filename',
              path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path (deprecated, use 'absolute')
              -- For explicit absolute path:
              -- path = 'absolute',
              shorting_rule = 'minimal', -- Other options: ' ञ ', '….', nil
            }
          },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' }
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { { 'filename', path = 1, shorting_rule = 'minimal' } }, -- or path = 'absolute'
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
      }
    end,
  },
  -- Edit enhancements
  { "vim-scripts/ReplaceWithRegister" },
  { "tpope/vim-surround" },
  { "tpope/vim-commentary" },
  { "Raimondi/delimitMate" },
  { "tommcdo/vim-exchange" },
  { "christoomey/vim-system-copy" },

  -- File types
  { "chrisbra/csv.vim" },
  { "sukima/xmledit" },
  --
  -- Navigation and search
  { "christoomey/vim-tmux-navigator" },
  {
    "ctrlpvim/ctrlp.vim",
    keys = {
      { "<leader>t", "<cmd>CtrlP<cr>",       desc = "CtrlP" },
      { "<leader>b", "<cmd>CtrlPBuffer<cr>", desc = "CtrlP Buffer" },
    },
    config = function()
      vim.g.ctrlp_map = '<leader>t'
      vim.g.ctrlp_cmd = 'CtrlP'
      vim.g.ctrlp_max_height = 35
      vim.g.ctrlp_switch_buffer = ''
      vim.g.ctrlp_user_command = { '.git', 'cd %s && git ls-files -co --exclude-standard' }

      -- Add any other CtrlP settings you want here
    end,
  },
  { "tpope/vim-fugitive" },
  { "tpope/vim-abolish" },
  {
    "Valloric/ListToggle",
    config = function()
      vim.g.lt_height = 10
    end,
  },
  {
    "jpalardy/vim-slime",
    config = function()
      vim.g.slime_target = "tmux"
      vim.g.slime_python_ipython = 1
      vim.g.slime_default_config = { socket_name = "default", target_pane = "{down-of}" }
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        snippet = { expand = function() end },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"]   = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<CR>"]    = cmp.mapping.confirm({ select = true }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        },
      })

      -- `/` search in buffer
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })

      -- `:` commands + file-paths
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        -- you can swap the order here if you prefer file-paths first:
        sources = cmp.config.sources(
          { { name = "cmdline" } }, -- complete :commands, :help, etc.
          { { name = "path" } }     -- then complete file-paths for args
        ),
      })
    end,
  },
  { import = "plugins" },
  {
    "ruifm/gitlinker.nvim",
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      -- this only runs when lazy.nvim has added
      -- gitlinker.nvim to runtimepath
      require("gitlinker").setup({
        remote                          = nil, -- force the use of a specific remote
        add_current_line_on_normal_mode = true,
        action_callback                 = require("gitlinker.actions").copy_to_clipboard,
        print_url                       = true,

        callbacks                       = {
          ["github.com"]             = require("gitlinker.hosts").get_github_type_url,
          ["gitlab.com"]             = require("gitlinker.hosts").get_gitlab_type_url,
          ["try.gitea.io"]           = require("gitlinker.hosts").get_gitea_type_url,
          ["codeberg.org"]           = require("gitlinker.hosts").get_gitea_type_url,
          ["bitbucket.org"]          = require("gitlinker.hosts").get_bitbucket_type_url,
          ["try.gogs.io"]            = require("gitlinker.hosts").get_gogs_type_url,
          ["git.sr.ht"]              = require("gitlinker.hosts").get_srht_type_url,
          ["git.launchpad.net"]      = require("gitlinker.hosts").get_launchpad_type_url,
          ["repo.or.cz"]             = require("gitlinker.hosts").get_repoorcz_type_url,
          ["git.kernel.org"]         = require("gitlinker.hosts").get_cgit_type_url,
          ["git.savannah.gnu.org"]   = require("gitlinker.hosts").get_cgit_type_url,
          ["kakarot%.chorse%.space"] = require("gitlinker.hosts").get_gitlab_type_url,
        },

        -- default mapping to call url generation with action_callback
        mappings                        = "<leader>gy",
      })
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  }
})
