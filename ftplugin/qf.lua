-- <CR> keeps its default behaviour (jump, leave the list open).
-- `o` jumps to the entry and closes the list behind you.
vim.keymap.set("n", "o", function()
  local idx = vim.fn.line(".")
  local loclist = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1].loclist == 1
  vim.cmd(idx .. (loclist and "ll" or "cc"))
  vim.cmd(loclist and "lclose" or "cclose")
end, { buffer = 0, silent = true, desc = "jump and close quickfix" })
