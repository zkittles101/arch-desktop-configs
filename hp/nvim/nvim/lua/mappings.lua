require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
vim.api.nvim_set_keymap('n', 'U', '<C-r>', { noremap = true })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
