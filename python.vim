nnoremap  <leader>gd :YcmCompleter GoTo<CR>
nnoremap <silent> <buffer> <leader>r :call pymode#rope#rename()<CR>

setlocal textwidth=120
let g:pymode_options_max_line_length=120
let g:pymode_lint_options_pep8 = {'max_line_length': g:pymode_options_max_line_length}
