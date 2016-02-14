nnoremap <leader>zh :!pandoc -s --toc %:p -o %:p:r.html<CR>
nnoremap <leader>zp :!pandoc -s %:p -o %:p:r.pdf<CR>
setlocal spell spelllang=en_gb

set smartindent
set expandtab
set tabstop=4
set shiftwidth=4
set expandtab

let g:vim_markdown_math=1
