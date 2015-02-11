setlocal noshowmatch
setlocal completeopt=longest,menuone,preview

" Automatically add new cs files to the nearest project on save
autocmd BufWritePost *.cs call OmniSharp#AddToProject()

"show type information automatically when the cursor stops moving
autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()

nnoremap <buffer> gd :OmniSharpGotoDefinition<cr>
nnoremap <buffer> <leader>fi :OmniSharpFindImplementations<cr>
nnoremap <buffer> <leader>ft :OmniSharpFindType<cr>
nnoremap <buffer> <leader>fs :OmniSharpFindSymbol<cr>
nnoremap <buffer> <leader>fu :OmniSharpFindUsages<cr>
nnoremap <buffer> <leader>fm :OmniSharpFindMembers<cr>
nnoremap <buffer> <leader>x  :OmniSharpFixIssue<cr>
nnoremap <buffer> <leader>fx :OmniSharpFixUsings<cr>
nnoremap <buffer> <leader>tt :OmniSharpTypeLookup<cr>
nnoremap <buffer> <leader>dc :OmniSharpDocumentation<cr>
nnoremap <buffer> <leader>nu :OmniSharpNavigateUp<cr>
nnoremap <buffer> <leader>nd :OmniSharpNavigateDown<cr>
