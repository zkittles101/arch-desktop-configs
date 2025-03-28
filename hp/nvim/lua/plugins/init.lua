return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				-- Customize or remove this keymap to your liking
				"<leader>fm",
				function()
					require("conform").format({ async = true })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		-- This will provide type hinting with LuaLS
		---@module "conform"
		---@type conform.setupOpts
		opts = {
			-- Define your formatters
			formatters_by_ft = {
				lua = { "stylua" },
				markdown = { "mdformat" },
				python = { "isort", "black" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
			},
			-- Set default options
			default_format_opts = {
				lsp_format = "fallback",
			},
			-- Set up format-on-save
			format_on_save = { timeout_ms = 500 },
			-- Customize formatters
			formatters = {
				shfmt = {
					prepend_args = { "-i", "2" },
				},
			},
		},
		init = function()
			-- If you want the formatexpr, here is the place to set it
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
	},

	{ "wakatime/vim-wakatime", lazy = false },
	{
		"3rd/image.nvim",
		-- enabled = false,
		lazy = true,
		opts = function()
			require("image").setup({
				backend = "kitty",
				integrations = {
					markdown = {
						enabled = true,
						clear_in_insert_mode = false,
						filetypes = { "markdown" },
						only_render_image_at_cursor = false,
						floating_windows = false,
						download_remote_images = true,
					},
				},
				max_width = nil,
				max_height = nil,
				max_height_window_percentage = 50,
				window_overlap_clear_enabled = true,
				window_overlap_clear_ft_ignore = {
					"cmp_menu",
					"cmp_docs",
					"snacks_notif",
					"scrollview",
					"scrollview_sign",
				},
				editor_only_render_when_focused = true, -- auto show/hide images when the editor gains/looses focus
				tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
				-- hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
			})
		end,
	},

	{
		"lervag/vimtex",
		lazy = false, -- we don't want to lazy load VimTeX
		-- tag = "v2.15", -- uncomment to pin to a specific release
		init = function()
			-- VimTeX configuration goes here, e.g.
			vim.g.vimtex_view_method = "zathura"
			vim.g.vimtex_view_forward_search_on_start = false
			vim.g.vimtex_compiler_latexmk = {
				aux_dir = "/home/e/.texfiles/",
				out_dir = "/mnt/DaBox/Markdown-Notes/.file-exports/",
			}
		end,
	},

	{ "shaunsingh/nord.nvim" },
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"stylua",
				"prettier",
			},
		},
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
	},

	{ "nvim-lua/plenary.nvim" },
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"vim",
				"lua",
				"vimdoc",
				"markdown",
				"markdown_inline",
				"html",
				"css",
				"go",
				"python",
			},
		},
	},
	-- { "VonHeikemen/fine-cmdline.nvim", dependencies = "MunifTanjim/nui.nvim", lazy = false },
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {--[[ things you want to change go here]]
		},
	},

	{ "akinsho/bufferline.nvim", version = "*", dependencies = "nvim-tree/nvim-web-devicons" },
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	},
	{
		"OXY2DEV/markview.nvim",
		lazy = false,
		init = function()
			-- Load the checkboxes module.
			require("markview.extras.checkboxes").setup()
			require("markview.extras.editor").setup()
			-- require("markview.presets").setup();
		end,
		config = function()
			local head = require("markview.presets").headings

			require("markview").setup({
				markdown = {
					headings = head.glow,
				},
			})
			local presets = require("markview.presets").horizontal_rules

			require("markview").setup({
				markdown = {
					horizontal_rules = presets.double,
				},
			})
			local tab = require("markview.presets").tables

			require("markview").setup({
				markdown = {
					tables = tab.rounded,
				},
			})
		end,
	},
	{
		"jbyuki/nabla.nvim",
	},

	{
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"crazyhulk/cmp-sign",
		"saadparwaiz1/cmp_luasnip",
	},
	{
		"mireq/luasnip-snippets",
		dependencies = { "L3MON4D3/LuaSnip" },
		init = function()
			-- Mandatory setup function
			require("luasnip_snippets.common.snip_utils").setup()
		end,
	},
	{
		"L3MON4D3/LuaSnip",
		version = "2.*",
		build = "make install_jsregexp",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		init = function()
			local ls = require("luasnip")
			ls.setup({
				-- Required to automatically include base snippets, like "c" snippets for "cpp"
				load_ft_func = require("luasnip_snippets.common.snip_utils").load_ft_func,
				ft_func = require("luasnip_snippets.common.snip_utils").ft_func,
				-- To enable auto expansin
				enable_autosnippets = true,
				-- Uncomment to enable visual snippets triggered using <c-x>
				-- store_selection_keys = '<c-x>',
			})
			-- LuaSnip key bindings
			vim.keymap.set({ "i", "s" }, "<Tab>", function()
				if ls.expand_or_jumpable() then
					ls.expand_or_jump()
				else
					vim.api.nvim_input("<C-V><Tab>")
				end
			end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
				ls.jump(-1)
			end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<C-E>", function()
				if ls.choice_active() then
					ls.change_choice(1)
				end
			end, { silent = true })
		end,
	},
	{ "rafamadriz/friendly-snippets" },
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{ "petertriho/cmp-git" },
	{
		"goolord/alpha-nvim",
	},
	{ "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
	{
		"luukvbaal/nnn.nvim",
		config = function()
			require("nnn").setup({
				explorer = {
					cmd = "nnn", -- command override (-F1 flag is implied, -a flag is invalid!)
					width = 24, -- width of the vertical split
					side = "topleft", -- or "botright", location of the explorer window
					session = "local", -- or "global" / "local" / "shared"
					tabs = true, -- separate nnn instance per tab
					fullscreen = false, -- whether to fullscreen explorer window when current tab is empty
				},
				picker = {
					cmd = "nnn", -- command override (-p flag is implied)
					style = {
						width = 0.9, -- percentage relative to terminal size when < 1, absolute otherwise
						height = 0.8, -- ^
						xoffset = 0.5, -- ^
						yoffset = 0.5, -- ^
						border = "rounded", -- border decoration for example "rounded"(:h nvim_open_win)
					},
					session = "local", -- or "global" / "local" / "shared"
					tabs = true, -- separate nnn instance per tab
					fullscreen = true, -- whether to fullscreen picker window when current tab is empty
				},
				auto_close = false, -- close tabpage/nvim when nnn is last window
				replace_netrw = nil, -- or "explorer" / "picker"
				mappings = {}, -- table containing mappings, see below
				windownav = { -- window movement mappings to navigate out of nnn
					left = "<C-w>h",
					right = "<C-w>l",
					next = "<C-w>w",
					prev = "<C-w>W",
				},
				buflisted = false, -- whether or not nnn buffers show up in the bufferlist
				quitcd = nil, -- or "cd" / tcd" / "lcd", command to run on quitcd file if found
				offset = false, -- whether or not to write position offset to tmpfile(for use in preview-tui)
			})
		end,
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},

	{
		"numToStr/Comment.nvim",
		opts = {
			-- add any options here
		},
		config = function()
			require("Comment").setup()
		end,
	},
}
