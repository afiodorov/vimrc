nnoremap gd :TernDef<CR>
nnoremap <leader>K :TernDocBrowse<CR>
nnoremap <leader>r :TernRename<CR>
nnoremap <leader>sr :TernRefs<CR>
inoremap <leader>f function

function! s:isDocShown()
if exists("g:TernDoc_is_shown")
unlet g:TernDoc_is_shown
execute "normal! \<C-W>k:bd\<cr>"
else
let g:TernDoc_is_shown = 1
execute "normal! :TernDoc\<cr>"
endif
endfunction
map K :call <SID>isDocShown()<cr>

set tabstop=2 shiftwidth=2

inoremap <leader>f function

" These options weill be overrriden at openbet
let file = expand("~/openbet/javascript.vim")
if filereadable(file)
	execute 'source '.file  
else
	set expandtab
	let g:syntastic_javascript_checkers=['jslint', 'gjslint']
endif
