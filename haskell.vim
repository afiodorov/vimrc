" Tab specific option
set tabstop=8                   "A tab is 8 spaces
set expandtab                   "Always uses spaces instead of tabs
set softtabstop=4               "Insert 4 spaces when tab is pressed
set shiftwidth=4                "An indent is 4 spaces
set smarttab                    "Indent instead of tab at start of line
set shiftround                  "Round spaces to nearest shiftwidth multiple
set nojoinspaces                "Don't convert spaces to tabs

setlocal iskeyword+='

nnoremap <leader>z :!ghc --make %:t<CR>:!./%:t:r<CR>

setlocal omnifunc=necoghc#omnifunc
setlocal formatprg=xargs\ pointfree

nnoremap <leader>gt :GhcModType<CR>
nnoremap <leader>gc :GhcModTypeClear<CR>
setlocal textwidth=79

let g:haskellmode_completion_ghc = 0
setlocal omnifunc=necoghc#omnifunc
