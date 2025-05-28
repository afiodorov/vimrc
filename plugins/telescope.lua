return {
	'nvim-telescope/telescope.nvim',
	dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
	config = function()
		require('telescope').setup {
			pickers = {
				find_files = {
					follow = true,
					theme = "ivy",
				}
			},
		}

		vim.keymap.set("n", "<leader>ec", function()
			require('telescope.builtin').find_files {
				cwd = vim.fn.stdpath("config")
			}
		end)

		vim.keymap.set("n", "<leader>ht", require('telescope.builtin').help_tags)
	end
}
