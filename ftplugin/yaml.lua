-- YAML is indentation-structured, so 'indent' folding matches the document tree
-- exactly and needs no treesitter parser.
vim.opt_local.foldmethod = "indent"
vim.opt_local.foldnestmax = 10
-- Open everything on load; folding is opt-in via zm / zM / zc.
vim.opt_local.foldlevel = 99
