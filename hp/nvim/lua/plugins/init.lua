return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },

 {
  "epwalsh/obsidian.nvim",
  version = "*",  -- recommended, use latest release instead of latest commit
  lazy = true,
  conceallevel = 3,
  ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",

    -- see below for full list of optional dependencies 👇
  },
  opts = {
    workspaces = {
      -- {
      --   name = "personal",
      --   path = "~/vaults/personal",
      -- },
      -- {
      --   name = "School Work",
      --   path = "/mnt/DaBox/Obsidian Vaults/School Work/",
      -- },
    },

    -- see below for full list of options 👇
  },
},

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server", "stylua",
        "html-lsp", "css-lsp", "prettier"
      },
    },

    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  },

  -- {'barrett-ruth/live-server.nvim',
  --       build = 'pnpm add -g live-server',
  --       cmd = { 'LiveServerStart', 'LiveServerStop' },
  --       config = true
  -- },
  { 'wakatime/vim-wakatime', lazy = false },

  { "nvim-lua/plenary.nvim" },

  {
    "nvchad/ui",
    config = function()
      require "nvchad"
    end
  },

  {
    "ellisonleao/glow.nvim",
    cmd = "Glow",
    config = function()
      require('glow').setup({
        style = "dark",
        width = 120,
      })
    end
  },
  --
  -- {
  --   "jbyuki/nabla.nvim",
  --   --stylua: ignore
  --   keys = {
  --     { "<leader>lx", function() require("nabla").popup({ border = "rounded" }) end, desc = "Scientific Notation Previewing", },
  --   },
  --   lazy = false,
  --   config = function()
  --     require("nabla").setup()
  --   end,
  -- },
  --
  {
    "nvchad/base46",
    lazy = true,
    build = function()
      require("base46").load_all_highlights()
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc", "markdown",
        "html", "css", "go", "python"
      },
    },
  },

  -- These are some examples, uncomment them if you want to see them work!
  -- {
  --   "neovim/nvim-lspconfig",
  --   config = function()
  --     require("nvchad.configs.lspconfig").defaults()
  --     require "configs.lspconfig"
  --   end,
  -- },
  --
  -- {
  -- 	"williamboman/mason.nvim",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"lua-language-server", "stylua",
  -- 			"html-lsp", "css-lsp" , "prettier"
  -- 		},
  -- 	},
  -- },
  --
}
