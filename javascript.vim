nnoremap <buffer> gd :TernDef<CR>
nnoremap <buffer> <leader>K :TernDocBrowse<CR>
nnoremap <buffer> <leader>r :TernRename<CR>
nnoremap <buffer> <leader>sr :TernRefs<CR>
inoremap <buffer> <leader>f function
inoremap <buffer> <leader>r require

function! s:isDocShown()
if exists("g:TernDoc_is_shown")
unlet g:TernDoc_is_shown
execute "normal! \<C-W>k:bd\<cr>"
else
let g:TernDoc_is_shown = 1
execute "normal! :TernDoc\<cr>"
endif
endfunction
map <buffer> K :call <SID>isDocShown()<cr>

set tabstop=2
set shiftwidth=2

inoremap <buffer> <leader>f function

if filereadable(expand('~/workrc/javascript.vim'))
	source ~/workrc/javascript.vim
else
	" These options weill be overriden at work
	set expandtab
	let g:syntastic_javascript_checkers=['jslint', 'jshint', 'gjslint']
endif
