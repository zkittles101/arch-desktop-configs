require "nvchad.mappings"

local map = vim.keymap.set
-- add yours here


map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

vim.api.nvim_set_keymap('n', 'U', '<C-r>', { noremap = true })
-- map("n", "<leader>m", "<cmd>Glow<cr>", {desc = "Markdown Preview"})

-- Toggle between TERMINAL mode and NTERMINAL (Normal Mode in Terminal)
map({ "t", "n" }, "<C-Space>", function()
  if vim.bo.buftype == "terminal" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
  else
    vim.cmd("startinsert") -- Enter terminal mode
  end
end, { desc = "Toggle between NTERMINAL and TERMINAL mode" })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Resize terminal buffer easily
map({"t", "n"}, "<A-Up>", "<C-\\><C-n>:resize +2<CR>i", { desc = "Increase terminal height" })
map({"t", "n"}, "<A-Down>", "<C-\\><C-n>:resize -2<CR>i", { desc = "Decrease terminal height" })
map({"t", "n"}, "<A-Left>", "<C-\\><C-n>:vertical resize -2<CR>i", { desc = "Decrease terminal width" })
map({"t", "n"}, "<A-Right>", "<C-\\><C-n>:vertical resize +2<CR>i", { desc = "Increase terminal width" })

-- Keymap for toggling spell checking
map({'n'}, '<Leader>sp', ':set spell!<CR>', {desc = "Toggle spell check"; noremap = true, silent = true })
map({'n'}, '<leader>rx', ':lua require("image").clear()<CR>', {desc = "clears image.nvim"})
map('n', '<leader>rl', ':lua require("image").setup()<CR>', {desc = "reloads image.nvim"})
--nabla
map({"n"}, '<leader>mp', ':lua require("nabla").popup()<CR>', {desc ="Popup Math preview" ; noremap=true})
map({"n"}, '<leader>mv', ':lua require("nabla").toggle_virt()<CR> ', {desc ="Math preview with virt_lines"; noremap= true})
-- MarkView
map({"n"}, "<leader>md", ":Markview toggle<CR>", {desc = "toggle markview"})
map({"n"}, "<leader>mc", ":Code edit<CR>", {desc = "edit codeblocks inside Markdown"})
map({"n"}, "<leader>mb", ":Checkbox toggle<CR>", {desc = "toggle checkbox status"})
