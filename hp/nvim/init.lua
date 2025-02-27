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

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")
dofile(vim.g.base46_cache .. "nvdash")

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


require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

-- Mason setup
require("mason").setup()

-- Mason LSP config setup
require("mason-lspconfig").setup({
  ensure_installed = { "pylsp", "ast_grep", "gopls", "cssls", "html", "quick_lint_js", "marksman", "tailwindcss", "ts_ls" },
})

-- LSP config setup
local lspconfig = require('lspconfig')

lspconfig.tailwindcss.setup {}
lspconfig.ts_ls.setup {}
lspconfig.html.setup {}
lspconfig.cssls.setup {}
lspconfig.quick_lint_js.setup {}
lspconfig.pylsp.setup {}
lspconfig.gopls.setup({})
lspconfig.ast_grep.setup {}
lspconfig.marksman.setup {}
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

-- Add to ~/.config/nvim/init.lua

-- Shared function to generate HTML (without opening browser)
local function generate_html()
  local md_file = vim.fn.expand('%:p')  -- Full path to current Markdown file
  local base_name = vim.fn.expand('%:t:r')  -- Filename without extension

  -- Define fixed paths (customize as needed)
  local web_exports = '/mnt/DaBox/Obsidian Vaults/Personal/web-exports/'
  local web_assets = '/mnt/DaBox/Obsidian Vaults/Personal/web-assets/'

  -- Construct paths with proper escaping for spaces
  local html_file = web_exports .. base_name .. '.html'
  local template = web_assets .. 'template.html'
  local css_file = web_assets .. 'style.css'

  -- Build Pandoc command
  local pandoc_cmd = string.format(
    "pandoc '%s' -o '%s' --template='%s' --katex --css='%s'",
    md_file, html_file, template, css_file
  )

  -- Execute silently (no 'Press ENTER' prompt)
  vim.cmd('silent !' .. pandoc_cmd)
  vim.notify("HTML generated: " .. html_file, vim.log.levels.INFO)
end

-- Keybinding 1: Generate HTML only
vim.keymap.set('n', '<leader>mg', generate_html, {
  noremap = true,
  desc = 'Generate HTML from Markdown (no preview)'
})

-- Keybinding 2: Generate HTML + Open/Refresh Browser
vim.keymap.set('n', '<leader>pmd', function()
  generate_html()  -- First generate the HTML

  -- Open in browser (reuses existing tab if possible)
  local html_file = '/mnt/DaBox/Obsidian Vaults/Personal/web-exports/'
    .. vim.fn.expand('%:t:r') .. '.html'
  -- Try to refresh existing tab first, fallback to new tab
  vim.cmd("silent !chromium '" .. html_file .. "'&")
end, {
  noremap = true,
  desc = 'Generate HTML and preview in browser'
})


if vim.version().minor < 10 then
  vim.notify "Please update neovim version to v0.10 at least! NvChad only supports v0.10+"
end
