" You can also open the definition/declaration, in a new vertical, horizontal,
" or tab, for the word under your cursor
nmap <buffer> <leader>ds <Plug>(go-def-split)
nmap <buffer> <leader>dv <Plug>(go-def-vertical)
nmap <buffer> <leader>dt <Plug>(go-def-tab)

" Open the relevant Godoc for the word under the cursor
" nmap <buffer> <leader>gd <Plug>(go-doc)
nmap <buffer> <leader>gv <Plug>(go-doc-vertical)

" Show a list of interfaces which is implemented by the type under your cursor
nmap <buffer> <leader>gi <Plug>(go-implements)

" Show type info for the word under your cursor
nmap <buffer> <leader>gt <Plug>(go-info)

" Rename the identifier under the cursor to a new name
nmap <buffer> <leader>gr <Plug>(go-rename)


setlocal textwidth=120
setlocal tabstop=4                   "A tab is 8 spaces
setlocal shiftwidth=4                " size of indent
setlocal noexpandtab
setlocal autoindent

" let g:ale_linters = {'go': ['gofmt', 'golint', 'govet', 'gobuild']}
let g:ale_linters = {'go': ['gofmt', 'golint', 'golangci-lint', 'govet', 'gopls']}
let g:go_rename_command = 'gopls'
