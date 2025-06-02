return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    {
      "lukas-reineke/indent-blankline.nvim",
      tag = "v2.20.8",        -- ⟵ pin to v2
      event = "BufReadPost",
      config = function()
        vim.opt.list = true
        require("indent_blankline").setup {
          space_char_blankline      = " ",
          show_current_context      = true,
          show_current_context_start = true,
        }
      end,
    },
    "kiyoon/treesitter-indent-object.nvim",
  },
  branch = 'master',
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require 'nvim-treesitter.configs'.setup {
      ignore_install = {},    -- list of parser names to skip, if any
      modules        = {},
      -- A list of parser names, or "all" (the listed parsers MUST always be installed)
      ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "python" },

      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- Automatically install missing parsers when entering buffer
      -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
      auto_install = false,

      highlight = {
        enable = true,
        disable = function(lang, buf)
          local _ = lang
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,   -- turns on `nvim_treesitter#indent()`  [oai_citation:0‡dynamiteFrog](https://dynamitefrog.com/posts/treesitter-neovim-config-cheatsheet/?utm_source=chatgpt.com)
      },
      textobjects = {
        select = {
          enable = true,
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            -- You can also add parameter textobjects
            ["ap"] = "@parameter.outer",
            ["ip"] = "@parameter.inner",
            ["ii"] = "@indent.inner",
            ["ai"] = "@indent.outer",
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]C"] = "@class.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[C"] = "@class.outer",
          },
        },
      },
    }

      require("treesitter_indent_object").setup()

      local tsio = require("treesitter_indent_object.textobj")
      vim.keymap.set({ "x", "o" }, "ii", function()
        tsio.select_indent_inner()
      end, { desc = "Select indent-inner block" })
      vim.keymap.set({ "x", "o" }, "iI", function()
        tsio.select_indent_inner(true, "V")
      end, { desc = "Select indent-inner (whole lines)" })

      vim.keymap.set({ "x", "o" }, "ai", function()
        tsio.select_indent_outer()
      end, { desc = "Select indent-outer block" })
      vim.keymap.set({ "x", "o" }, "aI", function()
        tsio.select_indent_outer(true)
      end, { desc = "Select indent-outer (whole lines)" })

  end
}
