require "nvchad.mappings"

local map = vim.keymap.set
-- add yours here

-- map ("n", "<leader>lx", "<cmd>nabla<cr>" , {desc = "latex Preview"})

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

vim.api.nvim_set_keymap('n', 'U', '<C-r>', { noremap = true })
map("n", "<leader>m", "<cmd>Glow<cr>", {desc = "Markdown Preview"})

-- Toggle between TERMINAL mode and NTERMINAL (Normal Mode in Terminal)
map({ "t", "n" }, "<C-Space>", function()
  if vim.bo.buftype == "terminal" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
  else
    vim.cmd("startinsert") -- Enter terminal mode
  end
end, { desc = "Toggle between NTERMINAL and TERMINAL mode" })-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Resize terminal buffer easily
map({"t", "n"}, "<A-Up>", "<C-\\><C-n>:resize +2<CR>i", { desc = "Increase terminal height" })
map({"t", "n"}, "<A-Down>", "<C-\\><C-n>:resize -2<CR>i", { desc = "Decrease terminal height" })
map({"t", "n"}, "<A-Left>", "<C-\\><C-n>:vertical resize -2<CR>i", { desc = "Decrease terminal width" })
map({"t", "n"}, "<A-Right>", "<C-\\><C-n>:vertical resize +2<CR>i", { desc = "Increase terminal width" })

-- Keymap for nabla.nvim
