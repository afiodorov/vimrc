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

" let g:pymode_python = 'python3'

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
let g:Tex_Leader=','
let maplocalleader='`'
" }}}

" tab to switch between files quickly {{{
nnoremap <tab> :e#<CR>
" }}}

" ctags {{{
let Tlist_Ctags_Cmd = "/usr/bin/ctags --fields=+l"
let Tlist_WinWidth = 50
map <silent> <f12> :!/usr/bin/ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --exclude=.git --exclude=node_modules .<CR>
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
let g:tagbar_width = 50

let g:tagbar_type_typescript = {
  \ 'ctagsbin' : 'tstags',
  \ 'ctagsargs' : '-f-',
  \ 'kinds': [
    \ 'e:enums:0:1',
    \ 'f:function:0:1',
    \ 't:typealias:0:1',
    \ 'M:Module:0:1',
    \ 'I:import:0:1',
    \ 'i:interface:0:1',
    \ 'C:class:0:1',
    \ 'm:method:0:1',
    \ 'p:property:0:1',
    \ 'v:variable:0:1',
    \ 'c:const:0:1',
  \ ],
  \ 'sort' : 0
\ }
" }}}

" catch trailing white spaces {{{
set listchars=tab:>-,trail:·,eol:$
nnoremap <silent> <leader>s :set nolist!<CR>
" }}}

" to gain back , functionality lost by remapping the comma {{{
nnoremap <Space> ,
" }}}

" Vundle {{{
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

Plugin 'vim-scripts/vis'
Plugin 'vim-scripts/ReplaceWithRegister'
Plugin 'chrisbra/csv.vim'
Plugin 'sukima/xmledit'
Plugin 'gregsexton/MatchTag'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'bling/vim-airline'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'kien/ctrlp.vim'
Bundle 'fisadev/vim-ctrlp-cmdpalette'
Plugin 'scrooloose/nerdtree.git'
Plugin 'tpope/vim-repeat'
Plugin 'scrooloose/nerdcommenter'
Plugin 'Valloric/YouCompleteMe'
Plugin 'Valloric/ListToggle'
Plugin 'vim-scripts/taglist.vim'
Plugin 'vim-scripts/Gundo'
Plugin 'majutsushi/tagbar'
Plugin 'plasticboy/vim-markdown'
Plugin 'vim-scripts/JavaScript-Indent'
Plugin 'digitaltoad/vim-jade'
Plugin 'Raimondi/delimitMate'
Plugin 'jpalardy/vim-slime'
Plugin 'w0rp/ale'
Plugin 'leafgarland/typescript-vim'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'fisadev/vim-isort'
Plugin 'python-mode/python-mode'
Plugin 'machakann/vim-swap'
"
" Python
Plugin 'kana/vim-textobj-user'
Plugin 'kana/vim-textobj-indent'
Plugin 'bps/vim-textobj-python'

call vundle#end()            " required
filetype plugin indent on    " required
" }}}

" better undo {{{
inoremap <C-w> <C-g>u<C-w>
inoremap <Space> <Space><C-g>u

" for latex
inoremap , ,<C-g>u
inoremap ` `<C-g>u
" }}}

set viminfo='10,\"100,:20,%,n~/viminfo

" Editing VIMRC {{{
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>sl :source ~/.vim/after/ftplugin/tex.vim<cr>
nnoremap <leader>sja :source ~/.vim/after/ftplugin/java.vim<cr>
nnoremap <leader>eja :vsplit ~/.vim/after/ftplugin/java.vim<cr>
nnoremap <leader>sjs :source ~/.vim/after/ftplugin/javascript.vim<cr>
nnoremap <leader>ejs :vsplit ~/.vim/after/ftplugin/javascript.vim<cr>
nnoremap <leader>sts :source ~/.vim/after/ftplugin/typescript.vim<cr>
nnoremap <leader>ets :vsplit ~/.vim/after/ftplugin/typescript.vim<cr>
nnoremap <leader>shs :source ~/.vim/after/ftplugin/haskell.vim<cr>
nnoremap <leader>ehs :vsplit ~/.vim/after/ftplugin/haskell.vim<cr>
nnoremap <leader>scs :source ~/.vim/after/ftplugin/cs.vim<cr>
nnoremap <leader>ecs :vsplit ~/.vim/after/ftplugin/cs.vim<cr>
nnoremap <leader>sgo :source ~/.vim/after/ftplugin/go.vim<cr>
nnoremap <leader>ego :vsplit ~/.vim/after/ftplugin/go.vim<cr>
nnoremap <leader>spy :source ~/.vim/after/ftplugin/python.vim<cr>
nnoremap <leader>epy :vsplit ~/.vim/after/ftplugin/python.vim<cr>
" }}}

" NERDtree {{{
nnoremap <F3> :NERDTreeToggle %:p:h<CR>
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
autocmd FileType typescript setlocal ts=4 sts=4 sw=4 expandtab
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

" cd to current directory {{{
nnoremap <leader>cd :cd %:p:h<CR>
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

" terminal settings {{{
set t_Co=256
if !&diff
    set background=light
endif

if &diff
	highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
	highlight DiffDelete cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
	highlight DiffChange cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
	highlight DiffText   cterm=bold ctermfg=10 ctermbg=88 gui=none guifg=bg guibg=Red
endif
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

nnoremap <leader>rd :redraw!<CR>

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

" {{{ Typescript
let g:ycm_semantic_triggers = {'typescript': ['.'], 'haskell': ['.']}
let g:ycm_complete_in_comments = 1
" }}}

" {{{ Vim-slime
let g:slime_target = "tmux"
let g:slime_python_ipython = 1
let g:slime_default_config = {"socket_name": "default", "target_pane": "{down-of}"}
" }}}

" Move the preview window to the bottom of the screen {{{
set splitbelow
" }}}

" delete dirs in netrw {{{
let g:netrw_localrmdir='rm -r'
" }}}

" YCM {{{
nnoremap <leader>gd :YcmCompleter GoToDefinition<CR>
nnoremap K :YcmCompleter GetDoc<CR>
nnoremap <leader>gc :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>gr :YcmCompleter GoToReferences<CR>

let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_filepath_completion_use_working_dir = 1
let g:ycm_always_populate_location_list = 1
" }}}

" CtrlP-CmdPallete {{{
nnoremap <C-x> :CtrlPCmdPalette<CR>
" }}}

" ale {{{
let g:ale_lint_on_save = 1
" }}}

" execute {{{
nnoremap <leader>ex :exe getline(line('.'))<cr>
" }}}
