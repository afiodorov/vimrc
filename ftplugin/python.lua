vim.keymap.set('n', '<leader>v', 'Obreakpoint()<Esc>', {
  buffer = true,
  noremap = true,
  silent = true,
  desc = "Insert breakpoint() on the line above"
})
