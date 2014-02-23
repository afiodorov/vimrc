let g:C_MapLeader=','
nnoremap <C-\> :tab split<CR> :exe 'tj' expand('<cword>')<CR>
nnoremap <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
inoremap <leader>s std::
function! s:insert_gates()
  let gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
  execute "normal! i#ifndef " . gatename
  execute "normal! o#define " . gatename . " "
  execute "normal! Go#endif /* " . gatename . " */"
  normal! kk
endfunction
autocmd BufNewFile *.{h,hpp} call <SID>insert_gates()

set syntax=cpp11
set tabstop=4 softtabstop=4 shiftwidth=4
nnoremap <leader>md :cd %:p:h/..<CR>:make debug -j4<CR>
nnoremap <leader>mr :cd %:p:h/..<CR>:make -j4<CR>
nnoremap <leader>mc :cd %:p:h/..<CR>:make clean<CR>
nnoremap <leader>z :cd %:p:h/..<CR>:make<CR>:!./out/%:t:r<CR>
