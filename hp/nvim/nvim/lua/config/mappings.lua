local map = vim.keymap.set
-- add yours here

map("n", ";", "<cmd>FineCmdline<CR>", { desc = "CMD enter command mode", noremap = true })
map("i", "jk", "<ESC>")

-- toggle terminal
map({ "i", "n", "v" }, "<C-t>", ":<C-\\><C-n>:ToggleTerm<CR>", { desc = "Toggle Terminal Window", noremap = true })
-- toggle file picker
map({ "n", "v", "t" }, "<leader>v", "<C-\\><C-n>:NnnPicker<CR>", { desc = "Toggle File Picker" })
map({ "n", "v", "t" }, "<C-n>", "<C-\\><C-n>:NnnExplorer<CR>", { desc = "Toggle File Explorer" })
-- exit terminal modes
map({ "t", "n" }, "<C-Space>", "<C-\\><C-n>")

-- open a new empty tab
map({ "n" }, "<leader>b", "<CMD>enew<CR>")
-- close a buffer tab
map({ "n" }, "<leader>x", "<CMD>bd<CR>")
-- move between tabs
map("n", "<Tab>", "<CMD>bnext<CR>")
map("n", "<S-Tab>", "<CMD>bprev<CR>")

-- navigations in toggled term

-- Move between windows and terminals
-- map({ "t", "n" }, "<C-h>", "<C-w>+h", { desc = "Focus to the left" })

-- bind control + s to save
map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Keymap for toggling spell checking
map({ "n" }, "<Leader>sp", "<CMD>set spell!<CR>", { desc = "Toggle spell check", noremap = true, silent = true })

-- image previews
map({ "n" }, "<leader>rx", ':lua require("image").clear()<CR>', { desc = "clears image.nvim" })
map("n", "<leader>rl", ':lua require("image").setup()<CR>', { desc = "reloads image.nvim" })

--nabla
map({ "n" }, "<leader>mp", '<CMD>lua require("nabla").popup()<CR>', { desc = "Popup Math preview", noremap = true })

-- nabla virt lines support
map(
	{ "n" },
	"<leader>mv",
	'<CMD>lua require("nabla").toggle_virt()<CR> ',
	{ desc = "Math preview with virt_lines", noremap = true }
)
-- MarkView
map({ "n" }, "<leader>mc", ":CodeEdit<CR>", { desc = "edit codeblocks inside Markdown" })
map({ "n" }, "<leader>mb", "<CMD>CheckboxToggle<CR>", { desc = "toggle checkbox status" })
