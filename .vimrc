set nocompatible
set lazyredraw
set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,~/.vim/after
set autoread
set backspace=indent,eol,start
syntax on

" when scrolling, keep cursor 1 lines away from screen border
set scrolloff=1

set autoindent
set undolevels=1000
set title " change terminal's title
set copyindent
set visualbell           " don't beep
set noerrorbells         " don't beep
set pastetoggle=<F4>
set hidden " manage multiple buffers effectively
set tags=./tags

:silent !mkdir -p ~/tmp
set backupdir=~/tmp/
set directory=~/tmp/

let g:C_Ctrl_j = 'off'
map Q <Nop>

if filereadable(expand('~/workrc/vimrc.vim'))
	source ~/workrc/vimrc.vim
	let g:is_at_work = 1
endif

" remember more commands {{{
set history=1000
" }}}

" faster way to access the directory of a file {{{
cabbr <expr> %% expand('%:p:h')
" }}}

" tab completion like in command line {{{
set wildmode=longest,list,full
set wildmenu

" Ignore these files when completing names and in Explorer
set wildignore=.svn,CVS,.git,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif
" }}}

" case-sensitivity {{{
set ignorecase
set smartcase
" }}}

" my leader {{{
let mapleader=","
let maplocalleader='`'
" }}}

" tab to switch between files quickly {{{
nnoremap <tab> :e#<CR>
" }}}

" ctags {{{
let Tlist_WinWidth = 50
map <F8> :TagbarToggle<cr>
let g:tagbar_show_linenumbers = 1

let g:tagbar_type_mkd = {
	\ 'ctagstype' : 'markdown',
	\ 'kinds' : [
		\ 'h:Heading_L1',
		\ 'i:Heading_L2',
		\ 'k:Heading_L3'
	\ ]
\ }
let g:tagbar_type_solidity = {
    \ 'ctagstype': 'solidity',
    \ 'kinds' : [
        \ 'c:contracts',
        \ 'e:events',
        \ 'f:functions',
        \ 'm:mappings',
        \ 'v:varialbes',
    \ ]
\ }
let g:tagbar_width = 50

" }}}

" catch trailing white spaces {{{
set listchars=tab:>-,trail:·,eol:$
nnoremap <silent> <leader>s :set nolist!<CR>
" }}}

" to gain back , functionality lost by remapping the comma {{{
nnoremap <Space> ,
" }}}

" Vundle {{{
call plug#begin()
Plug 'vyperlang/vim-vyper'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'chrisbra/csv.vim'
Plug 'sukima/xmledit'
Plug 'gregsexton/MatchTag'
Plug 'christoomey/vim-tmux-navigator'
Plug 'bling/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-abolish'
Plug 'kien/ctrlp.vim'
Plug 'fisadev/vim-ctrlp-cmdpalette'
Plug 'tpope/vim-commentary'
Plug 'Valloric/ListToggle'
Plug 'majutsushi/tagbar'
Plug 'plasticboy/vim-markdown'
Plug 'vim-scripts/JavaScript-Indent'
Plug 'Raimondi/delimitMate'
Plug 'jpalardy/vim-slime'
Plug 'jelera/vim-javascript-syntax'
Plug 'machakann/vim-swap'
Plug 'ludovicchabant/vim-gutentags'
Plug 'tommcdo/vim-exchange'
Plug 'christoomey/vim-system-copy'
Plug 'iden3/vim-circom-syntax'

" Python
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-indent'
Plug 'bps/vim-textobj-python'
Plug 'mgedmin/python-imports.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'pangloss/vim-javascript'    " JavaScript support
Plug 'leafgarland/typescript-vim' " TypeScript syntax
Plug 'maxmellon/vim-jsx-pretty'   " JS and JSX syntax
Plug 'jparise/vim-graphql'        " GraphQL syntax

call plug#end()
" }}}

" colors {{{
set background=light
hi CocFloating ctermfg=0 ctermbg=7
hi CocHintFloat ctermfg=0 ctermbg=7
" }}}

" better undo {{{
inoremap <C-w> <C-g>u<C-w>
inoremap <Space> <Space><C-g>u
" }}}

" Editing VIMRC {{{
nnoremap <leader>ev :vsplit ~/.vimrc<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>sjs :source ~/.vim/after/ftplugin/javascript.vim<cr>
nnoremap <leader>ejs :vsplit ~/.vim/after/ftplugin/javascript.vim<cr>
nnoremap <leader>sts :source ~/.vim/after/ftplugin/typescript.vim<cr>
nnoremap <leader>ets :vsplit ~/.vim/after/ftplugin/typescript.vim<cr>
nnoremap <leader>sgo :source ~/.vim/after/ftplugin/go.vim<cr>
nnoremap <leader>ego :vsplit ~/.vim/after/ftplugin/go.vim<cr>
nnoremap <leader>spy :source ~/.vim/after/ftplugin/python.vim<cr>
nnoremap <leader>epy :vsplit ~/.vim/after/ftplugin/python.vim<cr>
nnoremap <leader>svy :source ~/.vim/after/ftplugin/vyper.vim<cr>
nnoremap <leader>evy :vsplit ~/.vim/after/ftplugin/vyper.vim<cr>
nnoremap <leader>sso :source ~/.vim/after/ftplugin/solidity.vim<cr>
nnoremap <leader>eso :vsplit ~/.vim/after/ftplugin/solidity.vim<cr>
" }}}

" delete buffer, keep the split {{{
nnoremap <leader>x :bp\|bd #<CR>
" }}}

" Map ctrl-movement keys to window switching {{{
nnoremap <C-w><C-w> <C-w>p
nnoremap <C-w><leader>l <C-w>200l
nnoremap <C-w><leader>h <C-w>200h
" }}}

" spell dictionary {{{
setglobal spell spelllang=ru,en_gb
verbose set nospell
" syntax spell toplevel
set spellfile=~/.vim/dict.add
" }}}

" Vimscript file settings {{{
augroup filetype_vim
	autocmd!
	autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

" SH file settings {{{
augroup sh
    autocmd!
    "smart indent really only for C like languages
    autocmd FileType sh set nosmartindent autoindent
augroup END
" }}}

" Common file type settings {{{
autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
" }}}

" save read-only files as root {{{
cmap w!! %!sudo tee > /dev/null %
" }}}

" Search for the selected text in visual mode {{{
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
" }}}

" surround repeat {{{
silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)
" }}}

" ListToggle {{{
let g:lt_height = 10
" }}}

" set incsearch {{{
set incsearch
" }}}

" python mode {{{
" Activate rope
" Keys:
" K             Show python docs
" <Ctrl-Space>  Rope autocomplete
" <Ctrl-c>g     Rope goto definition
" <Ctrl-c>d     Rope show documentation
" <Ctrl-c>f     Rope find occurrences
" <Leader>b     Set, unset breakpoint (g:pymode_breakpoint enabled)
" [[            Jump on previous class or function (normal, visual, operator modes)
" ]]            Jump on next class or function (normal, visual, operator modes)
" [M            Jump on previous class or method (normal, visual, operator modes)
" ]M            Jump on next class or method (normal, visual, operator modes)
let g:pymode = 1
let g:pymode_rope = 1
let g:pymode_rope_completion = 0
" vim hangs without
let g:pymode_rope_lookup_project = 0

" Linting
let g:pymode_lint = 0
let g:pymode_lint_on_write = 1
let g:pymode_lint_cwindow = 0
let g:pymode_lint_checker=['pep8', 'pylint', 'pep257', 'pyflakes']
let g:pymode_lint_signs = 1

let g:pymode_doc = 1
let g:pymode_doc_bind = '<leader>K'

" Auto check on save
let g:pymode_lint_write = 1

" Support virtualenv
let g:pymode_virtualenv = 1

" Enable breakpoints plugin
let g:pymode_breakpoint = 1
let g:pymode_breakpoint_key = '<leader>dp'

" syntax highlighting
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_slow_sync = 1
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_syntax_space_errors = g:pymode_syntax_all

" Don't autofold code
let g:pymode_folding = 0

" Debugger
let g:pymode_breakpoint_bind = '<leader>v'

let g:pymode_motion = 1

" }}}

" quick resize {{{
if bufwinnr(1)
  nnoremap + <C-W>+
  nnoremap - <C-W>-
endif
" }}}

" relative and absolute number Vim 7.4 {{{
set relativenumber
set number
" }}}

" start profiling {{{
nnoremap <leader>sp :profile start profile.log<CR>:profile func *<CR>:profile file *<CR>
nnoremap <leader>ep :profile pause<CR>:noautocmd qall!<CR>
" }}}

" markdown {{{
let g:vim_markdown_folding_disabled=1
" }}}

set mouse=a

" }}}
"
" ctrlp {{{
nnoremap <leader>b :CtrlPBuffer<CR>
let g:ctrlp_map = '<leader>t'
let g:ctrlp_max_height=35
let g:ctrlp_switch_buffer= ''
" }}}

" Vim-airline {{{
" Always show statusline
set laststatus=2
let g:airline#extensions#tabline#enabled = 0
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1
" }}}

set rtp+=~/.fzf
set nowritebackup
set colorcolumn=+1

fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" Cyrril {{{
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0
highlight lCursor guifg=NONE guibg=Cyan
" }}}

" Select pasted {{{
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]''`]`'
" }}}

" {{{ Vim-slime
let g:slime_target = "tmux"
let g:slime_python_ipython = 1
let g:slime_default_config = {"socket_name": "default", "target_pane": "{down-of}"}
" }}}

" Move the preview window to the bottom of the screen {{{
set splitbelow
set splitright
" }}}

" delete dirs in netrw {{{
let g:netrw_localrmdir='rm -r'
" }}}

" CtrlP-CmdPallete {{{
nnoremap <C-x> :CtrlPCmdPalette<CR>
" }}}

" ale {{{
let g:ale_lint_on_save = 1
" }}}

" airline {{{
let g:airline#extensions#keymap#enabled = 0
let g:airline_section_y = ''
" }}}

" xclip {{{
function! GetVisualSelection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
	return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return shellescape(join(lines, "\n"), 1)
endfunction

function! Xclip(type, ...)
  let sel_save = &selection
  let &selection = "inclusive"
  let reg_save = @@

  if a:type == 'line'
    silent exe "normal! '[V']y"
  else
    silent exe "normal! `[v`]y"
  endif

  call system('pbcopy', @@)

  let &selection = sel_save
  let @@ = reg_save
endfunction

nnoremap <silent> <leader>yy V:w !pbcopy<CR><CR>l
nnoremap <silent> <leader>y :set opfunc=Xclip<CR>g@
xnoremap <silent> <leader>y :<C-u>silent execute "!echo " . GetVisualSelection() . " \| pbcopy"<CR>:redraw!<CR>
" }}}

" edit in working dir {{{
map <leader>ew :e <C-R>=expand("%:p:h") . "/" <CR>
" }}}

" set wrap {{{
command! -nargs=* Wrap set wrap linebreak nolist
command! -nargs=* NoWrap set nowrap nolinebreak
" }}}
