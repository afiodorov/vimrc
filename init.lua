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
vim.opt.updatetime = 300

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
vim.opt.wildignore = table.concat({
  "*/.git/*", "*/.svn/*", "*/CVS/*",                                     -- More robust with */ prefix
  "*.swp",
  "*.o", "*.obj", "*.a", "*.so", "*.dylib", "*.dll",                     -- Common compiled
  "*.class",                                                             -- Java
  "__pycache__", "*.pyc", ".Python", "*.egg-info", "pip-wheel-metadata", -- Python
  "node_modules", ".npm",                                                -- Node
  "target",                                                              -- Rust
  "build", "dist",                                                       -- Common build output
  ".DS_Store", "*.orig",                                                 -- OS specific / backups
  ".vscode", ".idea",                                                    -- IDE
  "*.zip", "*.gz", "*.bz2", "*.xz", "*.rar", "*.7z",                     -- Archives
  "*.png", "*.jpg", "*.jpeg", "*.gif", "*.bmp", "*.svg", "*.webp",       -- Images
  "*.pdf", "*.epub", "*.mobi",                                           -- Documents
  "*.mp3", "*.ogg", "*.flac", "*.wav", "*.m4a",                          -- Audio
  "*.mp4", "*.mkv", "*.webm", "*.mov", "*.avi",                          -- Video
  "*.log"
}, ",")

-- Case sensitivity in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Leader keys
vim.g.mapleader = ","
vim.g.maplocalleader = "`"

require("config.lazy")

-- Quick buffer switching
vim.api.nvim_set_keymap('n', '<tab>', ':e#<CR>', { noremap = true })

local map = vim.keymap.set

map('n', '<leader>ew', ':e <C-R>=expand("%:p:h") . "/" <CR>', { noremap = true })


-- Plugin specifications

vim.opt_global.completeopt = { "menuone", "noinsert", "noselect" }

-- Whitespace visualization
vim.opt.listchars = { tab = '>-', trail = '·', eol = '$' }
vim.api.nvim_set_keymap('n', '<leader>s', ':set nolist!<CR>', { noremap = true, silent = true })

-- Remap comma functionality
vim.api.nvim_set_keymap('n', '<Space>', ',', { noremap = true })

-- Color settings
vim.opt.background = "light"

-- Better undo in insert mode
vim.api.nvim_set_keymap('i', '<C-w>', '<C-g>u<C-w>', { noremap = true })
vim.api.nvim_set_keymap('i', '<Space>', '<Space><C-g>u', { noremap = true })

-- Keymap to "kill" the current buffer:
-- 1. :bp (bprevious) - Switches to the previous buffer in the bufferlist.
--    This makes the original current buffer (the one we want to kill)
--    the "alternate buffer" (referred to by '#').
-- 2. | - Command separator.
-- 3. :bd # (bdelete #) - Deletes the alternate buffer (which is the one
--    we originally intended to close).
-- The overall effect is closing the current buffer and switching to the
-- most recently used buffer before it.
vim.api.nvim_set_keymap('n', '<leader>x', ':bp|bd #<CR>',
  { noremap = true, desc = "Close current buffer and switch to previous" })

vim.keymap.set("n", "<leader>sv", "<cmd>source %<CR>")
vim.keymap.set("n", "<leader>l", ":.lua<CR>")
vim.keymap.set("v", "<leader>l", ":lua<CR>")

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
