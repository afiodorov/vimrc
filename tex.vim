" edit Vim Latex config {{{
nnoremap <leader>el :vsplit ~/.vim/ftplugin/tex.vim<cr>

" }}}"

" this is mostly a matter of taste. but LaTeX looks good with just a bit
" of indentation.
set sw=2
" TIP: if you write your \label's as \label{fig:something}, then if you
" type in \ref{fig: and press <C-n> you will automatically cycle through
" all the figure labels. Very useful!
set iskeyword+=:
nmap <leader>z :w<cr><leader>ll<C-O>
imap <f2> <Esc>:w<cr><leader>ll<C-O>a

let Tlist_WinWidth = 30 
nnoremap <F8> :TlistToggle<CR>

imap <localleader>bf <Plug>Tex_MathBF
imap <localleader>bb <Plug>Tex_MathBB
imap <localleader>cal <Plug>Tex_MathCal

call IMAP(',Z','\mathbb{Z}','tex')
call IMAP(',N','\mathbb{N}','tex')
call IMAP(',R','\mathbb{R}','tex')
call IMAP(',C','\mathbb{C}','tex')
call IMAP(',Ec','\mathcal{E}','tex')
call IMAP(',Pi','\Pi','tex')
call IMAP(',1(','\id \left( <++> \right)<++>','tex')
call IMAP(',1','\id','tex')
call IMAP(',Pr','\mathbb{P} \left( <++> \right)<++>','tex')
call IMAP(',Pf','\mathbb{P}_{<++>} \left( <++> \right)<++>','tex')
call IMAP(',Ex','\mathbb{E} \left[ <++> \right]<++>','tex')
call IMAP(',Ef','\mathbb{E}_{<++>} \left[ <++> \right]<++>','tex')
call IMAP('`exp','\exp \left( <++> \right)<++>','tex')
call IMAP('`log','\log \left( <++> \right)<++>','tex')
call IMAP('`suml','\sum\limits_{<++>}^{<++>} <++>','tex')
call IMAP('`S','\sum_{<++>}^{<++>} <++>','tex')
call IMAP('`d','\textrm{d}','tex')
call IMAP('`I','\int_{<++>}^{<++>} <++> \;\textrm{d} <++>','tex')
call IMAP('`intl','\int\limits_{<++>}^{<++>} <++> \;\textrm{d} <++>','tex')
call IMAP('`prod','\prod_{<++>}^{<++>} <++>','tex')
call IMAP('`P','\prod_{<++>}^{<++>} <++>','tex')
call IMAP('`sub','\begin{subarray}{l} <++> \\ <++> \end{subarray}<++>','tex')
call IMAP('||','|<++>|<++>','tex')
call IMAP('`inf','\inf_{<++>} \left\{ <++> \right\}<++>','tex')
call IMAP('`sup','\sup_{<++>} \left\{ <++> \right\}<++>','tex')
call IMAP('`min{','\min_{<++>} \left\{ <++> \right\}<++>','tex')
call IMAP('`min ','\min_{<++>} <++> <++>','tex')
call IMAP('`max{','\max_{<++>} \left\{ <++> \right\}<++>','tex')
call IMAP('`max ','\max_{<++>} <++>','tex')
call IMAP('`1/','\frac{1}{<++>}<++>','tex')
call IMAP('`lab','\label{<++>}<++>','tex')

set textwidth=80

" Remove \label from align
let g:Tex_Env_align = "%\<CR>\\begin{align}\<CR><++>\<CR>\\end{align}\<CR>%"

" Disable conversion of " to `` etc. by latex-suite
let g:Tex_SmartKeyQuote = 0

" Syntax for LaTeX files with embedded Python
" environments. {{{
"let b:current_syntax = ''
"unlet b:current_syntax
"runtime! syntax/tex.vim
"
"let b:current_syntax = ''
"unlet b:current_syntax
"syntax include @TeX syntax/tex.vim
"
"let b:current_syntax = ''
"unlet b:current_syntax
"syntax include @Python syntax/python.vim
"syntax region pythonCode matchgroup=Snip start="\\begin{python}" end="\\end{python}" containedin=@TeX contains=@Python
"
"hi link Snip SpecialComment
"let b:current_syntax = 'pytex'
" }}}

" ctags {{{
let tlist_tex_settings   = 'latex;s:sections;g:graphics;l:labels;f:functions'
let tlist_make_settings  = 'make;m:makros;t:targets'
set iskeyword=@,48-57,_,-,192-255
" set iskeyword=@,48-57,_,-,:,192-255
" }}}

setlocal spell
let g:Tex_GotoError=0
let g:AutoPairs = {}
