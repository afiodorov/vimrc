" size of a hard tabstop
set tabstop=4

" size of an "indent"
set shiftwidth=4

" a combination of spaces and tabs are used to simulate tab stops at a width
" other than the (hard)tabstop
set softtabstop=4

" let g:EclimCompletionMethod = 'omnifunc'
nnoremap <silent> <buffer> <leader>i :JavaImportOrganize<cr>
nnoremap <silent> <buffer> <leader>d :JavaDocSearch -x declarations<cr>
nnoremap <silent> <buffer> <cr> :JavaSearchContext<cr>
nnoremap <buffer> <leader>f :%JavaFormat<cr>
nnoremap <buffer> <leader>z :Mvn package<cr>:!java -Xms512m -cp ~/cplus/minPaths/target/minPaths-1.0-SNAPSHOT.jar com.geo.Main < ~/cplus/minPaths/src/test/java/com/geo/500.txt<cr>
nnoremap <buffer> <leader>r :JavaRename
