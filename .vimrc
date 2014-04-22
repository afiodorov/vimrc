set nocompatible
set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME
set autoread
set backspace=2
set backspace=indent,eol,start
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
set wildmenu
set wildmode=list:longest

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
map <silent> <S-F8> :cd %:p:h<CR>:!/usr/bin/ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
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
let g:tagbar_width = 30
" }}}

" catch trailing white spaces {{{
set listchars=tab:>-,trail:·,eol:$
nnoremap <silent> <leader>s :set nolist!<CR>
" }}}

" turn off search highlighting{{{
nnoremap <silent> <leader>hc :silent :nohlsearch<CR>
" }}}

" to gain back , functionality lost by remapping the comma {{{
nnoremap <Space> , 
" }}}

" colorscheme {{{
" Toggle the zenburn colorscheme from low to high contrast and vice versa
function! s:toggleHighContrast()
if exists("g:zenburn_high_Contrast")
unlet g:zenburn_high_Contrast
colorscheme default
else
let g:zenburn_high_Contrast = 1
colorscheme zenburn
endif
endfunction
colorscheme default 
map <leader>cs :call <SID>toggleHighContrast()<cr>
" }}}

" Vundle {{{
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'matchit.zip'
Bundle 'gregsexton/MatchTag'
Bundle 'christoomey/vim-tmux-navigator'
Bundle 'vcscommand.vim'
Bundle 'marijnh/tern_for_vim'
Bundle 'altercation/vim-colors-solarized.git'
"Bundle 'davidhalter/jedi-vim'
Bundle 'klen/python-mode'
Bundle 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-surround'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'L9'
Bundle 'a.vim'
Bundle 'FuzzyFinder'
Bundle 'git://git.wincent.com/command-t.git'
Bundle 'git://github.com/scrooloose/nerdtree.git'
" Bundle 'c.vim'
Bundle 'tpope/vim-repeat'
Bundle 'scrooloose/syntastic'
Bundle 'scrooloose/nerdcommenter'
Bundle 'fholgado/minibufexpl.vim'
"Bundle 'jcf/vim-latex'
Bundle 'Valloric/YouCompleteMe'
Bundle 'Valloric/ListToggle'
Bundle 'vim-scripts/taglist.vim'
Bundle 'vim-scripts/Gundo'
Bundle 'majutsushi/tagbar'
Bundle 'plasticboy/vim-markdown'
Bundle 'jelera/vim-javascript-syntax'
Bundle 'vim-scripts/JavaScript-Indent'
Bundle 'pangloss/vim-javascript'
Bundle 'nathanaelkane/vim-indent-guides'
Bundle 'digitaltoad/vim-jade'
Bundle 'jiangmiao/auto-pairs'

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'
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

" to enable the saving and restoring of screen positions {{{
let g:screen_size_restore_pos = 1
let g:screen_size_by_vim_instance = 1
" }}}

" System register {{{
set clipboard=unnamedplus
" }}}

" Alt key does not focus on menu bar {{{
set winaltkeys=no
" }}}

set viminfo='10,\"100,:20,%,n~/viminfo

" Editing VIMRC {{{
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>sl :source ~/.vim/ftplugin/tex.vim<cr>
nnoremap <leader>sja :source ~/.vim/ftplugin/java.vim<cr>
nnoremap <leader>eja :vsplit ~/.vim/ftplugin/java.vim<cr>
nnoremap <leader>sjs :source ~/.vim/ftplugin/javascript.vim<cr>
nnoremap <leader>ejs :vsplit ~/.vim/ftplugin/javascript.vim<cr>
" }}}

" fast <esc> {{{
inoremap jk <Esc>
inoremap JK <Esc>
" }}}

" {{{ remove character return
nnoremap <leader>sm :%s///g<CR>
" }}}

" NERDtree {{{
nnoremap <F3> :NERDTreeToggle<CR>
" }}}


" buffer navigation like firefox {{{
noremap gt :bnext<cr>
noremap gT :bprevious<cr>
" }}}

" Map ctrl-movement keys to window switching {{{
" noremap <C-k> <C-w><Up>
" noremap <C-j> <C-w><Down>
" noremap <C-l> <C-w><Right>
" noremap <C-h> <C-w><Left>
" }}}

" spell dictionary {{{
setglobal spell spelllang=en_gb
verbose set nospell
" syntax spell toplevel
set spellfile=~/.vim/dict.add
" }}}

" quick save {{{
nnoremap <leader>w :update<cr>
" }}}

" highlighting long lines {{{
highlight OverLength ctermbg=red ctermfg=darkred guibg=#FFD9D9
nnoremap <silent> <leader>hl :match OverLength /\%81v.\+/<CR>
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

" delete words like in Word {{{
inoremap <C-BS> <C-W>
" }}}

" save read-only files as root {{{
cmap w!! %!sudo tee > /dev/null %
" }}}

" Add title case to ~ {{{
function! TwiddleCase(str)
  if a:str ==# toupper(a:str)
    let result = tolower(a:str)
  elseif a:str ==# tolower(a:str)
    let result = substitute(a:str,'\(\<\w\+\>\)', '\u\1', 'g')
  else
    let result = toupper(a:str)
  endif
  return result
endfunction
vnoremap ~ ygv"=TwiddleCase(@")<CR>Pgv
" }}}

" regex very magic {{{
:command! -nargs=1 S let @/ = escape('<args>', '\')
nnoremap <leader>/ :call EscapeBuffer()<CR>/\v<C-R>i
nnoremap / /\V
nnoremap <leader>sr :call EscapeBuffer()<CR>:%s/\v<C-R>i
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
let g:ycm_register_as_syntastic_checker=0
let g:syntastic_always_populate_loc_list=1

let g:syntastic_cpp_compiler='g++-4.7'
let g:syntastic_cpp_compiler_options=' -std=c++11'
let g:syntastic_cpp_checkers=['gcc', 'ycm'] 

let g:syntastic_javascript_checkers=['jslint', 'gjslint']

let g:syntastic_c_compiler='gcc-4.8'
let g:syntastic_cpp_checkers=['gcc', 'ycm']
let g:syntastic_c_compiler_options=' -std=c99'
" }}}

" ListToggle {{{
let g:lt_height = 10
" }}}

" escape buffer {{{
function! EscapeBuffer ()
	let @i=escape(@", '\\/.*$^~[]{}()!@|')
endfunction
" }}}

" set incsearch {{{
set incsearch
" }}}

" gundo: visual tree of changes {{{
map <leader>lc :GundoToggle<CR>
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
let g:pymode_rope = 0
let g:pymode_paths = ['/home/tom/cplus/PAMpython/']
" run key
let g:pymode_run = 1
let g:pymode_run_key = '<leader>z'

" Documentation
let g:pymode_doc = 0

" Linting
let g:pymode_lint = 1
let g:pymode_lint_hold = 0
let g:pymode_lint_cwindow = 0
let g:pymode_lint_signs = 1
let g:pymode_lint_checker = "pyflakes,pep8"
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

let g:jedi#use_tabs_not_buffers = 0
let g:jedi#popup_on_dot = 0
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

" insert empty line with enter {{{
" nnoremap <CR> o<ESC>
" }}}

" paste below the line {{{
nnoremap <silent> <leader>p :call append(line('.'), substitute(@+, '\n$', '', ''))<CR>
" }}}

" terminal settings {{{
if $COLORTERM == 'gnome-terminal'
  set t_Co=256
  set background=light
  " let g:solarized_termcolors=256
  set mouse=a
  colorscheme solarized
endif
" }}}

" command-t refresh {{{
nnoremap <F5> :CommandTFlush<CR>
" }}}

" youcompleteme go to definition {{{
nnoremap <leader>gd :YcmCompleter GoToDefinitionElseDeclaration<CR>
" }}}

" cscope {{{
"if has('cscope')
  "nmap <S-F11> :!find . -iname '*.c' -o -iname '*.cpp' -o -iname '*.h' -o -iname '*.hpp' > cscope.files<CR>
  "\:!cscope -b -i cscope.files -f cscope.out<CR>
  "\:cs reset<CR>
  "set cscopetag cscopeverbose

  "if has('quickfix')
    "set cscopequickfix=s-,c-,d-,i-,t-,e-
  "endif

  "cnoreabbrev csa cs add
  "cnoreabbrev csf cs find
  "cnoreabbrev csk cs kill
  "cnoreabbrev csr cs reset
  "cnoreabbrev css cs show
  "cnoreabbrev csh cs help

  "command! -nargs=0 Cscope cs add $VIMSRC/src/cscope.out $VIMSRC/src
"endif
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

" UltiSnips {{{
let g:UltiSnipsExpandTrigger="<C-K>"
let g:UltiSnipsJumpForwardTrigger="<C-K>"
let g:UltiSnipsJumpBackwardTrigger="<C-K>"
let g:UltiSnipsListSnippets="<C-L>"
" }}}
