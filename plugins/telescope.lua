return {
  'nvim-telescope/telescope.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' } },
  config = function()
    require('telescope').setup {
      pickers = {
        find_files = {
          follow = true,
          theme = "ivy",
        }
      },
      extensions = {
        fzf = {}
      }
    }

    require('telescope').load_extension('fzf')

    vim.keymap.set("n", "<leader>ev", function()
      require('telescope.builtin').find_files {
        cwd = vim.fn.stdpath("config")
      }
    end)

    vim.keymap.set("n", "<leader>ep", function()
      require('telescope.builtin').find_files {
        cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
      }
    end)

    vim.keymap.set("n", "<leader>ht", require('telescope.builtin').help_tags)
    vim.keymap.set("n", "<leader>gg", require "plugins.telescope.multigrep".setup)
  end
}
