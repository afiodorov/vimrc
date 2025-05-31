---@diagnostic disable: undefined-global

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

vim.cmd('filetype plugin indent on')

vim.opt.shell = vim.fn.exepath('bash')

-- General settings
vim.opt.lazyredraw = true
vim.opt.scrolloff = 1
vim.opt.undolevels = 1000
vim.opt.title = true
vim.opt.copyindent = true
vim.opt.visualbell = true
vim.opt.errorbells = false
vim.opt.tags = "./tags"

-- Backup and swap directories
local home = vim.fn.expand('$HOME')
local tmp_dir = home .. '/tmp'

vim.fn.system('mkdir -p ' .. tmp_dir)
vim.opt.backupdir = tmp_dir .. '//'
vim.opt.directory = tmp_dir .. '//'

-- Disable Ctrl-j in C files
vim.g.C_Ctrl_j = 'off'

-- Directory expansion in command mode
vim.cmd([[cabbr <expr> %% expand('%:p:h')]])

-- Wildmenu and ignore patterns
vim.opt.wildmode = "longest,list,full"
vim.opt.wildignore = ".svn,CVS,.git,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif"

-- Case sensitivity in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Leader keys
vim.g.mapleader = ","
vim.g.maplocalleader = "`"

-- Quick buffer switching
vim.api.nvim_set_keymap('n', '<tab>', ':e#<CR>', { noremap = true })

local map = vim.keymap.set

map('n', '<leader>ew', ':e <C-R>=expand("%:p:h") . "/" <CR>', { noremap = true })


-- Plugin specifications

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
	{
		"majutsushi/tagbar",
		config = function()
			vim.g.tagbar_width = 50
			vim.g.tagbar_show_linenumbers = 1
			vim.api.nvim_set_keymap('n', '<F8>', ':TagbarToggle<CR>', { noremap = true, silent = true })
			vim.g.tagbar_type_mkd = {
				ctagstype = 'markdown',
				kinds = { 'h:Heading_L1', 'i:Heading_L2', 'k:Heading_L3' }
			}
			vim.g.tagbar_type_solidity = {
				ctagstype = 'solidity',
				kinds = { 'c:contracts', 'e:events', 'f:functions', 'm:mappings', 'v:varialbes' }
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
		"neoclide/coc.nvim",
		branch = "release",
	},
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
		},
		config = function()
			-- 1️⃣ Install mason + mason-lspconfig
			require('mason').setup()
			require('mason-lspconfig').setup({
				ensure_installed = { 'lua_ls' }, -- or 'sumneko_lua' if you prefer older name
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
				end,
			})
		end,
	},
	-- Completion Engine
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
					{ { name = "path" } } -- then complete file-paths for args
				),
			})
		end,
	},
	{ import = "plugins.metals" },
	{ import = "plugins.telescope" },
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
})

vim.opt_global.completeopt = { "menuone", "noinsert", "noselect" }

-- Whitespace visualization
vim.opt.listchars = { tab = '>-', trail = '·', eol = '$' }
vim.api.nvim_set_keymap('n', '<leader>s', ':set nolist!<CR>', { noremap = true, silent = true })

-- Remap comma functionality
vim.api.nvim_set_keymap('n', '<Space>', ',', { noremap = true })

-- Color settings
vim.opt.background = "light"
vim.cmd([[
hi CocFloating ctermfg=0 ctermbg=7
hi CocHintFloat ctermfg=0 ctermbg=7
]])

-- Better undo in insert mode
vim.api.nvim_set_keymap('i', '<C-w>', '<C-g>u<C-w>', { noremap = true })
vim.api.nvim_set_keymap('i', '<Space>', '<Space><C-g>u', { noremap = true })

-- Quick edit configurations
local function map_config_edit(key, file)
	vim.api.nvim_set_keymap('n', '<leader>e' .. key, ':vsplit ' .. file .. '<CR>', { noremap = true })
end

map_config_edit('v', '~/.config/nvim/init.lua')

-- Delete buffer, keep split
vim.api.nvim_set_keymap('n', '<leader>x', ':bp|bd #<CR>', { noremap = true })

vim.keymap.set("n", "<leader><leader>l", "<cmd>source %<CR>")
vim.keymap.set("n", "<leader>l", ":.lua<CR>")
vim.keymap.set("v", "<leader>l", ":lua<CR>")

-- Window navigation
vim.api.nvim_set_keymap('n', '<C-w><C-w>', '<C-w>p', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-w><leader>l', '<C-w>200l', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-w><leader>h', '<C-w>200h', { noremap = true })

-- Spell settings
vim.opt.spelllang = "ru,en_gb"
vim.opt.spell = false
vim.opt.spellfile = "~/.config/nvim/spell/dict.add"

-- Filetype specific settings
vim.cmd([[
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

augroup sh
    autocmd!
    autocmd FileType sh setlocal nosmartindent autoindent
augroup END

autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
]])

-- Save as root
vim.cmd([[cmap w!! w !sudo tee > /dev/null %]])

-- Visual mode search
vim.cmd([[
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
]])

-- Incsearch
vim.opt.incsearch = true

-- Quick resize
vim.api.nvim_set_keymap('n', '+', '<C-W>+', { noremap = true })
vim.api.nvim_set_keymap('n', '-', '<C-W>-', { noremap = true })

-- Line numbers
vim.opt.relativenumber = true
vim.opt.number = true

-- FZF
vim.opt.rtp:append("~/.fzf")

-- Misc settings
vim.opt.colorcolumn = "+1"

-- Strip trailing whitespaces
-- Cyrillic keyboard layout
vim.opt.keymap = "russian-jcukenwin"
vim.opt.iminsert = 0
vim.opt.imsearch = 0
vim.cmd("highlight lCursor guifg=NONE guibg=Cyan")

-- Select pasted text
vim.api.nvim_set_keymap('n', 'gp', '`[v`]', { noremap = true, expr = true })

-- Split settings
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Netrw settings
vim.g.netrw_localrmdir = 'rm -r'

-- CtrlP-CmdPalette
vim.api.nvim_set_keymap('n', '<C-x>', ':CtrlPCmdPalette<CR>', { noremap = true })

-- Wrap commands
vim.cmd([[
command! -nargs=* Wrap set wrap linebreak nolist
command! -nargs=* NoWrap set nowrap nolinebreak
]])

-- Create parent directories when saving
vim.cmd([[command! W execute 'silent !mkdir -p %:h' | w]])

-- Paste without overwriting register
vim.api.nvim_set_keymap('x', '<leader>p', '"_dP', { noremap = true })


local function trim_trailing_whitespace()
	local save = vim.fn.winsaveview()
	for i = 1, vim.api.nvim_buf_line_count(0) do
		local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
		local trimmed = line:gsub("%s+$", "")
		if line ~= trimmed then
			vim.api.nvim_buf_set_lines(0, i - 1, i, false, { trimmed })
		end
	end
	vim.fn.winrestview(save)
end

vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup,
	pattern = "*",
	callback = function()
		trim_trailing_whitespace()
	end,
})


_G.copy_visual_selection_to_clipboard = function()
	local old_reg = vim.fn.getreg('"')
	local old_regtype = vim.fn.getregtype('"')
	vim.cmd([[normal! `<v`>y]])
	local selection = vim.fn.getreg('"')
	vim.fn.setreg('"', old_reg, old_regtype)
	vim.fn.system('pbcopy', selection)
	print("Selection copied to clipboard")
end

vim.api.nvim_set_keymap('v', '<leader>y', [[:lua copy_visual_selection_to_clipboard()<CR>]],
	{ noremap = true, silent = true })
