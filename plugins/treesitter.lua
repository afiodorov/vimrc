-- Compatibility shim for nvim-treesitter (master branch) on Neovim >= 0.12.
--
-- Neovim 0.12 removed the `all = false` option from
-- `vim.treesitter.query.add_predicate` / `add_directive`: handlers are now
-- always called with `match` as `table<integer, TSNode[]>` (a list of nodes per
-- capture) instead of `table<integer, TSNode>`. nvim-treesitter's master branch
-- still registers single-node handlers, so e.g. opening a markdown file with a
-- fenced code block blows up in `set-lang-from-info-string!` with
--   treesitter.lua:197: attempt to call method 'range' (a nil value)
--
-- Re-register the affected handlers, unwrapping the node list first.
local function fix_query_handlers()
  -- Load nvim-treesitter's own versions first, so ours override them.
  pcall(require, "nvim-treesitter.query_predicates")

  local query = require "vim.treesitter.query"
  local opts = { force = true, all = true }

  ---@param nodes TSNode|TSNode[]|nil
  ---@return TSNode|nil
  local function first(nodes)
    if type(nodes) == "table" then
      return nodes[1]
    end
    return nodes
  end

  local html_script_type_languages = {
    ["importmap"] = "json",
    ["module"] = "javascript",
    ["application/ecmascript"] = "javascript",
    ["text/ecmascript"] = "javascript",
  }

  local injection_language_aliases = {
    ex = "elixir",
    pl = "perl",
    sh = "bash",
    uxn = "uxntal",
    ts = "typescript",
  }

  local function lang_from_markdown_info_string(alias)
    return vim.filetype.match { filename = "a." .. alias }
      or injection_language_aliases[alias]
      or alias
  end

  query.add_predicate("nth?", function(match, _pattern, _bufnr, pred)
    local node = first(match[pred[2]])
    local n = tonumber(pred[3])
    if node and n and node:parent() and node:parent():named_child_count() > n then
      return node:parent():named_child(n) == node
    end
    return false
  end, opts)

  query.add_predicate("is?", function(match, _pattern, bufnr, pred)
    -- Avoid circular dependencies
    local locals = require "nvim-treesitter.locals"
    local node = first(match[pred[2]])
    if not node then
      return true
    end
    local _, _, kind = locals.find_definition(node, bufnr)
    return vim.tbl_contains({ unpack(pred, 3) }, kind)
  end, opts)

  query.add_predicate("kind-eq?", function(match, _pattern, _bufnr, pred)
    local node = first(match[pred[2]])
    if not node then
      return true
    end
    return vim.tbl_contains({ unpack(pred, 3) }, node:type())
  end, opts)

  query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
    local node = first(match[pred[2]])
    if not node then
      return
    end
    local type_attr_value = vim.treesitter.get_node_text(node, bufnr)
    local configured = html_script_type_languages[type_attr_value]
    if configured then
      metadata["injection.language"] = configured
    else
      local parts = vim.split(type_attr_value, "/", {})
      metadata["injection.language"] = parts[#parts]
    end
  end, opts)

  query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
    local node = first(match[pred[2]])
    if not node then
      return
    end
    local alias = vim.treesitter.get_node_text(node, bufnr):lower()
    metadata["injection.language"] = lang_from_markdown_info_string(alias)
  end, opts)

  query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
    local id = pred[2]
    local node = first(match[id])
    if not node then
      return
    end
    local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
    metadata[id] = metadata[id] or {}
    metadata[id].text = string.lower(text)
  end, opts)
end

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
    fix_query_handlers()

    require 'nvim-treesitter.configs'.setup {
      ignore_install = {},    -- list of parser names to skip, if any
      modules        = {},
      -- A list of parser names, or "all" (the listed parsers MUST always be installed)
      ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "python", "typescript", "tsx" },

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
