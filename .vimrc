set nocompatible
set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,~/.vim/after
set autoread
set backspace=indent,eol,start
set scrolloff=1
set autoindent
set undolevels=1000
set title " change terminal's title
set copyindent
set visualbell           " don't beep
set noerrorbells         " don't beep
set pastetoggle=<F4>
set hidden " manage multiple buffers effectively
set tags=./tags;/

:silent !mkdir -p ~/tmp
set backupdir=~/tmp/
set directory=~/tmp/

let g:C_Ctrl_j = 'off'
map Q <Nop>
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
let Tlist_Ctags_Cmd = "/usr/bin/ctags"
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

Plugin 'chrisbra/csv.vim'
Plugin 'vim-scripts/gitignore'
Plugin 'sukima/xmledit'
Plugin 'matchit.zip'
Plugin 'gregsexton/MatchTag'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'marijnh/tern_for_vim'
Plugin 'bling/vim-airline'
Plugin 'tpope/vim-fugitive'
Plugin 'gregsexton/gitv'
Plugin 'tpope/vim-surround'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'L9'
Plugin 'FuzzyFinder'
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/nerdtree.git'
Plugin 'tpope/vim-repeat'
Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdcommenter'
Plugin 'fholgado/minibufexpl.vim'
Plugin 'jcf/vim-latex'
Plugin 'Valloric/YouCompleteMe'
Plugin 'Valloric/ListToggle'
Plugin 'vim-scripts/taglist.vim'
Plugin 'vim-scripts/Gundo'
Plugin 'majutsushi/tagbar'
Plugin 'plasticboy/vim-markdown'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'vim-scripts/JavaScript-Indent'
Plugin 'pangloss/vim-javascript'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'digitaltoad/vim-jade'
Plugin 'Raimondi/delimitMate'
Plugin 'jpalardy/vim-slime'
" Haskell
Plugin 'bitc/vim-hdevtools'
Plugin 'eagletmt/neco-ghc'
Plugin 'Shougo/vimproc'
Plugin 'eagletmt/ghcmod-vim'
Plugin 'lukerandall/haskellmode-vim'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-eunuch'
" Typescript
Plugin 'leafgarland/typescript-vim'
Plugin 'clausreinke/typescript-tools'
Plugin 'jason0x43/vim-js-indent'
" C sharp
Plugin 'OmniSharp/omnisharp-vim'
" Scala
Plugin 'derekwyatt/vim-scala'
" R
Plugin 'jcfaria/Vim-R-plugin'
" Python
Plugin 'klen/python-mode'
Plugin 'kana/vim-textobj-user'
Plugin 'kana/vim-textobj-indent'
Plugin 'bps/vim-textobj-python'

call vundle#end()            " required
filetype plugin indent on    " required
" }}}

" vim-latex {{{
set shellslash

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generatet a file-name.
set grepprg=grep\ -nH\ $*

let g:tex_flavor='latex'
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_MultipleCompileFormats='pdf'
let g:Tex_CompileRule_pdf = 'pdflatex -shell-escape -file-line-error -synctex=1 --interaction=nonstopmode $* >/dev/null'
let g:Tex_HotKeyMappings = 'align*,align,equation,bmatrix'
let g:Tex_ViewRule_pdf = 'evince'
let g:Tex_AutoFolding = 0
filetype plugin indent on
set omnifunc=syntaxcomplete#Complete
syntax on
" }}}

" better undo {{{
inoremap <C-w> <C-g>u<C-w>
inoremap <Space> <Space><C-g>u

" for latex
inoremap , ,<C-g>u
inoremap ` `<C-g>u
" }}}

" System register {{{
"set clipboard=unnamedplus
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

" Syntastic {{{
let g:syntastic_check_on_open=1
let g:syntastic_enable_signs=1
let g:syntastic_always_populate_loc_list=1


let g:syntastic_r_checkers=['lint']
let g:syntastic_r_lint_styles = 'list(spacing.indentation.notabs, spacing.indentation.evenindent)'

let g:syntastic_cpp_compiler='g++-4.8'
let g:syntastic_cpp_compiler_options=' -std=c++11'
let g:syntastic_cpp_checkers=['gcc', 'ycm']


let g:syntastic_python_checkers=['pep8', 'python']

let g:syntastic_c_compiler='gcc-4.8'
let g:syntastic_cpp_checkers=['gcc', 'ycm']
let g:syntastic_c_compiler_options=' -std=c99'
let g:syntastic_mode_map = {'mode': 'active'}
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

" Documentation
let g:pymode_doc = 1
let g:pymode_doc_bind = 'K'

" Linting
let g:pymode_lint = 1
let g:pymode_lint_hold = 0
let g:pymode_lint_cwindow = 0
let g:pymode_lint_signs = 1
let g:pymode_lint_checker = "pep8"
let g:pymode_lint_onfly = 1

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
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_syntax_space_errors = g:pymode_syntax_all

" Don't autofold code
let g:pymode_folding = 0

" Debugger
let g:pymode_breakpoint_bind = '<leader>v'
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
set background=light
" let g:solarized_termcolors=256
set mouse=a
" }}}

" ctrlp {{{
nnoremap <leader>b :CtrlPBuffer<CR>
let g:ctrlp_map = '<leader>t'
let g:ctrlp_max_height=35
let g:ctrlp_switch_buffer= ''
" }}}

" youcompleteme go to definition {{{
nnoremap <leader>gd :YcmCompleter GoToDefinitionElseDeclaration<CR>
" }}}

" {{{ Stab
" put all this in your .vimrc or a plugin file
command! -nargs=* Stab call Stab()
function! Stab()
  let l:tabstop = 1 * input('set shiftwidth=')

  if l:tabstop > 0
    " do we want expandtab as well?
    let l:expandtab = confirm('set expandtab?', "&Yes\n&No\n&Cancel")
    if l:expandtab == 3
      " abort?
      return
    endif

    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop

    if l:expandtab == 1
      setlocal expandtab
    else
      setlocal noexpandtab
    endif
  endif

  " show the selected options
  try
    echohl ModeMsg
    echon 'set tabstop='
    echohl Question
    echon &l:ts
    echohl ModeMsg
    echon ' shiftwidth='
    echohl Question
    echon &l:sw
    echohl ModeMsg
    echon ' sts='
    echohl Question
    echon &l:sts . ' ' . (&l:et ? '  ' : 'no')
    echohl ModeMsg
    echon 'expandtab'
  finally
    echohl None
  endtry
endfunction
" }}}

if filereadable(expand('~/workrc/vimrc.vim'))
	source ~/workrc/vimrc.vim
endif
" Vim-airline {{{
" Always show statusline
set laststatus=2
let g:airline#extensions#tabline#enabled = 0
" }}}

set rtp+=~/.fzf
set nowritebackup
set colorcolumn=80

nnoremap <silent> <leader>yf :let @+=expand("%")<CR>
nnoremap <leader>gr :exec 'Gread '.expand("%")<CR>
autocmd FocusGained silent :redraw!

nnoremap <leader>d :redraw!<CR>

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
let g:slime_paste_file = tempname()
let g:slime_python_ipython = 1
" }}}

" Haskell {{{
let g:haddock_browser = "/usr/bin/google-chrome"
let g:haddock_docdir = "/home/tom/.cabal/share/doc"
let g:ghc = "/usr/bin/ghc"
" }}}

" Csharp {{{
let g:syntastic_cs_checkers = ['syntax', 'semantic', 'issues']
let g:ycm_csharp_server_port = 2000
"}}}

" Move the preview window to the bottom of the screen {{{
set splitbelow
" }}}

" Minibuf Explorer {{{
" above
let g:miniBufExplSplitBelow = 0
" }}}

" delete dirs in netrw {{{
let g:netrw_localrmdir='rm -r'
" }}}
