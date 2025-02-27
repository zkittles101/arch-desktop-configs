return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
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


  {
    'jbyuki/nabla.nvim',
  },

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
        "vim", "lua", "vimdoc", "markdown", "markdown_inline",
        "html", "css", "go", "python"
      },
    },
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
        out_dir = "/home/e/.texfiles/",
      }
    end
  },

  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    init = function()
      -- Load the checkboxes module.
      require("markview.extras.checkboxes").setup();
      require("markview.extras.editor").setup();
      -- require("markview.presets").setup();
    end,
    config = function()
      local head = require("markview.presets").headings;

      require("markview").setup({
        markdown = {
          headings = head.glow }
      });
      local presets = require("markview.presets").horizontal_rules;

      require("markview").setup({
        markdown = {
          horizontal_rules = presets.double
        }
      });
      local tab = require("markview.presets").tables;

      require("markview").setup({
        markdown = {
          tables = tab.rounded
        }
      });
    end,

  },

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
        window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "snacks_notif", "scrollview", "scrollview_sign" },
        editor_only_render_when_focused = true,  -- auto show/hide images when the editor gains/looses focus
        tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
        -- hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened

      })
    end,
  },

  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    -- ft = "markdown",
    event = {
      "BufReadPre /mnt/DaBox/Obsidian Vaults/School Work/*.md",
      "BufNewFile /mnt/DaBox/Obsidian Vaults/School Work/*.md",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "School Work",
          path = "/mnt/DaBox/Obsidian Vaults/School Work/",
        },
      },
      log_level = vim.log.levels.INFO,
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },
      mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        -- Toggle check-boxes.
        ["<leader>ch"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
        -- Smart action depending on context, either follow link or toggle checkbox.
        ["<cr>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        }
      },
      -- Either 'wiki' or 'markdown'.
      preferred_link_style = "wiki",
      ---@param url string
      follow_url_func = function(url)
        -- Open the URL in the default web browser.
        -- vim.fn.jobstart({"open", url})  -- Mac OS
        vim.fn.jobstart({ "xdg-open", url }) -- linux
        -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
        -- vim.ui.open(url) -- need Neovim 0.10.0+
      end,
      picker = {
        -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
        name = "telescope.nvim",
      },
      ui = {
        enable = false,
      },
    },
  },

}
