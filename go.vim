setlocal textwidth=120
setlocal tabstop=4
setlocal shiftwidth=4
setlocal noexpandtab
setlocal autoindent

let g:ale_linters = {'go': ['gofmt', 'golint', 'golangci-lint', 'govet', 'gopls']}
let g:go_rename_command = 'gopls'
