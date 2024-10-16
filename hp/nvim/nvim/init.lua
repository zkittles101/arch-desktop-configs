vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
    config = function()
      require "options"
    end,
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")
dofile(vim.g.base46_cache .. "nvdash")

require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

-- Mason setup
require("mason").setup()

-- Mason LSP config setup
require("mason-lspconfig").setup({
    ensure_installed = { "pylsp" },
})

-- LSP config setup
local lspconfig = require('lspconfig')

require'lspconfig'.html.setup{}
require'lspconfig'.cssls.setup{}
require'lspconfig'.quick_lint_js.setup{}

lspconfig.pylsp.setup{}

-- nvdash lua file 

local api = vim.api
local config = require "nvconfig"
local new_cmd = api.nvim_create_user_command

vim.o.statusline = "%!v:lua.require('nvchad.stl." .. config.ui.statusline.theme .. "')()"

if config.ui.tabufline.enabled then
  require "nvchad.tabufline.lazyload"
end

-- Command to toggle NvDash
new_cmd("Nvdash", function()
  if vim.g.nvdash_displayed then
    require("nvchad.tabufline").close_buffer()
  else
    require("nvchad.nvdash").open()
  end
end, {})

new_cmd("NvCheatsheet", function()
  if vim.g.nvcheatsheet_displayed then
    vim.cmd "bw"
  else
    require("nvchad.cheatsheet." .. config.cheatsheet.theme)()
  end
end, {})

vim.schedule(function()
  -- load nvdash only on empty file
  if config.ui.nvdash.load_on_startup then
    local buf_lines = api.nvim_buf_get_lines(0, 0, 1, false)
    local no_buf_content = api.nvim_buf_line_count(0) == 1 and buf_lines[1] == ""
    local bufname = api.nvim_buf_get_name(0)

    if bufname == "" and no_buf_content then
      require("nvchad.nvdash").open()
    end
  end

  require "nvchad.au"
end)

if vim.version().minor < 10 then
  vim.notify "Please update neovim version to v0.10 at least! NvChad only supports v0.10+"
end

-- nvdash setup

-- local M = {}
-- local api = vim.api
-- local fn = vim.fn
--
-- dofile(vim.g.base46_cache .. "nvdash")
--
-- local config = require("nvconfig").ui.nvdash
--
-- local headerAscii = config.nvdash.header
-- local emmptyLine = string.rep(" ", vim.fn.strwidth(headerAscii[1]))
-- --
-- table.insert(headerAscii, 1, emmptyLine)
-- table.insert(headerAscii, 2, emmptyLine)
-- --
-- headerAscii[#headerAscii + 1] = emmptyLine
-- headerAscii[#headerAscii + 1] = emmptyLine
-- --
-- api.nvim_create_autocmd("BufLeave", {
--   callback = function()
--     if vim.bo.ft == "nvdash" then
--       vim.g.nvdash_displayed = false
--     end
--   end,
-- })
--
-- local map = function(keys, action)
--   for _, v in ipairs(keys) do
--     vim.keymap.set("n", v, action, { buffer = true })
--   end
-- end
--
-- M.open = function()
--   local buttons = config.buttons
--   local nvdashWidth = #headerAscii[1] + 3
--
--   local max_height = #headerAscii + 4 + (2 * #buttons) -- 4  = extra spaces i.e top/bottom
--   local get_win_height = api.nvim_win_get_height
--
--   vim.g.nv_previous_buf = vim.api.nvim_get_current_buf()
--
--   local buf = vim.api.nvim_create_buf(false, true)
--   local win = api.nvim_get_current_win()
--
--   -- switch to larger win if cur win is small
--   if nvdashWidth + 6 > api.nvim_win_get_width(0) then
--     vim.api.nvim_set_current_win(api.nvim_list_wins()[2])
--     win = api.nvim_get_current_win()
--   end
--
--   api.nvim_win_set_buf(win, buf)
--
--   local header = headerAscii
--
--   local function addSpacing_toBtns(txt1, txt2)
--     local btn_len = fn.strwidth(txt1) + fn.strwidth(txt2)
--     local spacing = fn.strwidth(header[1]) - btn_len
--     return txt1 .. string.rep(" ", spacing - 1) .. txt2 .. " "
--   end
--
--   local function addPadding_toHeader(str)
--     local pad = (api.nvim_win_get_width(win) - fn.strwidth(str)) / 2
--     return string.rep(" ", math.floor(pad)) .. str .. " "
--   end
--
--   local dashboard = {}
--
--   for _, val in ipairs(header) do
--     table.insert(dashboard, val .. " ")
--   end
--
--   for _, val in ipairs(buttons) do
--     local str = type(val) ~= "table" and val() or nil
--     table.insert(dashboard, str or addSpacing_toBtns(val[1], val[2]) .. " ")
--     table.insert(dashboard, header[1] .. " ")
--   end
--
--   local result = {}
--
--   -- make all lines available
--   for i = 1, math.max(get_win_height(win), max_height) do
--     result[i] = ""
--   end
--
--   local headerStart_Index = math.abs(math.floor((get_win_height(win) / 2) - (#dashboard / 2))) + 1 -- 1 = To handle zero case
--   local abc = math.abs(math.floor((get_win_height(win) / 2) - (#dashboard / 2))) + 1 -- 1 = To handle zero case
--
--   -- set ascii
--   for _, val in ipairs(dashboard) do
--     result[headerStart_Index] = addPadding_toHeader(val)
--     headerStart_Index = headerStart_Index + 1
--   end
--
--   api.nvim_buf_set_lines(buf, 0, -1, false, result)
--
--   local nvdash = api.nvim_create_namespace "nvdash"
--   local horiz_pad_index = math.floor((api.nvim_win_get_width(win) / 2) - (nvdashWidth / 2)) - 2
--
--   for i = abc, abc + #header do
--     api.nvim_buf_add_highlight(buf, nvdash, "NvDashAscii", i, horiz_pad_index, -1)
--   end
--
--   for i = abc + #header - 2, abc + #dashboard do
--     api.nvim_buf_add_highlight(buf, nvdash, "NvDashButtons", i, horiz_pad_index, -1)
--   end
--
--   api.nvim_win_set_cursor(win, { abc + #header, math.floor(vim.o.columns / 2) - 13 })
--
--   local first_btn_line = abc + #header + 2
--   local keybind_lineNrs = {}
--
--   for _, _ in ipairs(buttons) do
--     table.insert(keybind_lineNrs, first_btn_line - 2)
--     first_btn_line = first_btn_line + 2
--   end
--
--   -- disable left/right
--   map({ "h", "l", "<left>", "<right>" }, "")
--
--   map({ "k", "<up>" }, function()
--     local cur = fn.line "."
--     local target_line = cur == keybind_lineNrs[1] and keybind_lineNrs[#keybind_lineNrs] or cur - 2
--     api.nvim_win_set_cursor(win, { target_line, math.floor(vim.o.columns / 2) - 13 })
--   end)
--
--   map({ "j", "<down>" }, function()
--     local cur = fn.line "."
--     local target_line = cur == keybind_lineNrs[#keybind_lineNrs] and keybind_lineNrs[1] or cur + 2
--     api.nvim_win_set_cursor(win, { target_line, math.floor(vim.o.columns / 2) - 13 })
--   end)
--
--   -- pressing enter on
--   vim.keymap.set("n", "<CR>", function()
--     for i, val in ipairs(keybind_lineNrs) do
--       if val == fn.line "." then
--         local action = buttons[i][3]
--
--         if type(action) == "string" then
--           vim.cmd(action)
--         elseif type(action) == "function" then
--           action()
--         end
--       end
--     end
--   end, { buffer = true })
--
--   require("nvchad.utils").set_cleanbuf_opts "nvdash"
-- end
--
-- return M
--

