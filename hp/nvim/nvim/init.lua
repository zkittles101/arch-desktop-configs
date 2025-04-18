vim.opt.termguicolors = true

require("config.lazy")
require("config.alpha")
vim.schedule(function()
	require("config.mappings")
end)
-- themes
vim.cmd.colorscheme("nord")

vim.opt.mousemoveevent = true

local bufferline = require("bufferline")
bufferline.setup({
	options = {
		mode = "buffers", -- set to "tabs" to only show tabpages instead
		style_preset = bufferline.style_preset.minimal, -- or bufferline.style_preset.minimal,
		themable = true, -- allows highlight groups to be overriden i.e. sets highlights as default
		numbers = "none",
		indicator = {
			style = "underline",
		},
		-- max_name_length = 18,
		-- max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
		truncate_names = true, -- whether or not tab names should be truncated
		-- tab_size = 18,
		diagnostics = "none",
		-- NOTE: this will be called a lot so don't do any heavy processing here
		custom_filter = function(buf_number, buf_numbers)
			-- filter out filetypes you don't want to see
			if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
				return true
			end
			-- filter out by buffer name
			if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
				return true
			end
			-- filter out based on arbitrary rules
			-- e.g. filter out vim wiki buffer from tabline in your work repo
			if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
				return true
			end
			-- filter out by it's index number in list (don't show first buffer)
			if buf_numbers[1] ~= buf_number then
				return true
			end
		end,
		offsets = {
			{
				filetype = "nnn",
				text = " ",
				text_align = "left",
				separator = false,
			},
		},
		color_icons = true, -- whether or not to add the filetype icon highlights
		get_element_icon = function(element)
			-- element consists of {filetype: string, path: string, extension: string, directory: string}
			-- This can be used to change how bufferline fetches the icon
			-- for an element e.g. a buffer or a tab.
			-- e.g.
			local icon, hl = require("nvim-web-devicons").get_icon_by_filetype(element.filetype, { default = false })
			return icon, hl
		end,
		show_buffer_icons = true, -- disable filetype icons for buffers
		show_buffer_close_icons = true,
		show_close_icon = false,
		show_tab_indicators = true,
		show_duplicate_prefix = true, -- whether to show duplicate buffer prefix
		duplicates_across_groups = true, -- whether to consider duplicate paths in different groups as duplicates
		persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
		move_wraps_at_ends = false, -- whether or not the move command "wraps" at the first or last position
		-- can also be a table containing 2 custom separators
		-- [focused and unfocused]. eg: { '|', '|' }
		separator_style = "thin",
		enforce_regular_tabs = false,
		always_show_bufferline = true,
		auto_toggle_bufferline = true,
		hover = {
			enabled = true,
			delay = 200,
			reveal = { "close" },
		},
		sort_by = "relative_directory",
		pick = {
			alphabet = "abcdefghijklmopqrstuvwxyzABCDEFGHIJKLMOPQRSTUVWXYZ1234567890",
		},
	},
})

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"texlab",
		"textlsp",
		"pylsp",
		"gopls",
		"cssls",
		"html",
		"quick_lint_js",
		"prosemd_lsp",
		"tailwindcss",
		"ts_ls",
	},
})

-- LSP config setup
local lspconfig = require("lspconfig")

lspconfig.tailwindcss.setup({})
lspconfig.ts_ls.setup({})
lspconfig.textlsp.setup({})
lspconfig.html.setup({})
lspconfig.cssls.setup({})
lspconfig.quick_lint_js.setup({})
lspconfig.pylsp.setup({})
lspconfig.gopls.setup({})
lspconfig.prosemd_lsp.setup({})
lspconfig.lua_ls.setup({})
lspconfig.texlab.setup({})

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Telescope bindings
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", ":cd $HOME | Telescope find_files<CR>", { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Telescope old files" })

-- setup completions
local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				local entries = cmp.get_entries()
				cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })

				if #entries == 1 then
					cmp.confirm()
				end
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				local entries = cmp.get_entries()
				cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })

				if #entries == 1 then
					cmp.confirm()
				end
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" }, -- For luasnip users.
		{ name = "render-markdown" },
		{ name = "path" },
		{ name = "buffer" },
		{ name = "cmp-sign" },
		{ name = "calc" },
	}),
})

-- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "git" },
	}, {
		{ name = "buffer" },
	}),
})
require("cmp_git").setup()
-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
	matching = { disallow_symbol_nonprefix_matching = false },
})

-- Set up lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require("lspconfig")["pylsp"].setup({ capabilities = capabilities })
require("lspconfig")["lua_ls"].setup({ capabilities = capabilities })
require("lspconfig")["gopls"].setup({ capabilities = capabilities })
require("lspconfig")["prosemd_lsp"].setup({ capabilities = capabilities })
require("lspconfig")["textlsp"].setup({ capabilities = capabilities })
require("lspconfig")["texlab"].setup({ capabilities = capabilities })
-- lualine status line
-- require("lualine").setup({ options = { theme = "nord" } })

require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "nord",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		always_show_tabline = true,
		globalstatus = false,
		refresh = {
			statusline = 100,
			tabline = 100,
			winbar = 100,
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { "filename" },
		lualine_x = { "fileformat", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {},
})

-- freindly snippets
require("luasnip.loaders.from_vscode").lazy_load()

--copy to system clipboard
vim.api.nvim_set_option("clipboard", "unnamedplus")

-- Enable persistent undo
vim.opt.undofile = true

-- Shared function to generate HTML (without opening browser)
local function generate_html()
	local md_file = vim.fn.expand("%:p") -- Full path to current Markdown file
	local base_name = vim.fn.expand("%:t:r") -- Filename without extension

	-- Define fixed paths (customize as needed)
	local web_exports = "/mnt/DaBox/Markdown-Notes/.web-exports/"
	local web_assets = "/mnt/DaBox/Markdown-Notes/.web-assets/"

	-- Construct paths with proper escaping for spaces
	local html_file = web_exports .. base_name .. ".html"
	local template = web_assets .. "template.html"
	local css_file = web_assets .. "style.css"

	-- Build Pandoc command
	local pandoc_cmd =
		string.format("pandoc '%s' -o '%s' --template='%s' --katex --css='%s'", md_file, html_file, template, css_file)

	-- for embedding exported pages in a markdown file thats also getting exported, make sure you link the html file just by name since all exports will be places in the .web-exports directory

	-- Execute silently (no 'Press ENTER' prompt)
	vim.cmd("silent !" .. pandoc_cmd)
	vim.notify("HTML generated: " .. html_file, vim.log.levels.INFO)
end

-- Keybinding 1: Generate HTML only
vim.keymap.set("n", "<leader>mg", generate_html, {
	noremap = true,
	desc = "Generate HTML from Markdown (no preview)",
})

-- Keybinding 2: Generate HTML + Open/Refresh Browser
vim.keymap.set("n", "<leader>pmd", function()
	generate_html() -- First generate the HTML

	-- Open in browser (reuses existing tab if possible)
	local html_file = "/mnt/DaBox/Markdown-Notes/.web-exports/" .. vim.fn.expand("%:t:r") .. ".html"
	-- Try to refresh existing tab first, fallback to new tab
	vim.cmd("silent !chromium '" .. html_file .. "'&")
end, {
	noremap = true,
	desc = "Generate HTML and preview in browser",
})
