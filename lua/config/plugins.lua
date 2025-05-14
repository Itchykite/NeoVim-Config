-- 📌 Instalacja i konfiguracja pluginów
require("lazy").setup({

    { "github/copilot.vim" },

    -- 🔧 LSP dla Rust
    {
      "neovim/nvim-lspconfig",
      config = function()
        local lspconfig = require("lspconfig")

        -- Rust
        lspconfig.rust_analyzer.setup({
          settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              checkOnSave = { command = "clippy" },
            }
          }
        })

        -- C++
        lspconfig.clangd.setup({})

        -- Lua
        lspconfig.lua_ls.setup({
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace = { library = vim.api.nvim_get_runtime_file("", true) },
              telemetry = { enable = false },
            }
          }
        })

        -- HTML, CSS, JS, TS
        lspconfig.html.setup({})
        lspconfig.cssls.setup({})
        lspconfig.tsserver.setup({})
      end
    },

    -- rust-tools
    {
      "simrat39/rust-tools.nvim",
      dependencies = { "neovim/nvim-lspconfig" },
      config = function()
        local rt = require("rust-tools")
        rt.setup({
          server = {
            settings = {
              ["rust-analyzer"] = {
                cargo = { allFeatures = true },
                checkOnSave = { command = "clippy" },
              }
            }
          }
        })
      end
    },

    -- Telescope
    {
      "nvim-telescope/telescope.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        local telescope = require("telescope")
        telescope.setup({})
        vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>")
        vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>")
        vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>")
        vim.keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>")
      end
    },

    -- Mason (LSP installer)
    {
      "williamboman/mason.nvim",
      config = function()
        require("mason").setup()
      end
    },
    {
      "williamboman/mason-lspconfig.nvim",
      dependencies = { "mason.nvim" },
      config = function()
        require("mason-lspconfig").setup({
          ensure_installed = {
            "clangd", "lua_ls", "pyright",
            "html", "cssls", "tsserver"
          }
        })
      end
    },

    -- Autopairs
    {
      "windwp/nvim-autopairs",
      config = function()
        require("nvim-autopairs").setup({})
      end
    },

    -- Motyw
    {
      "folke/tokyonight.nvim",
      config = function()
        vim.cmd("colorscheme tokyonight")
      end
    },

    -- NvimTree
    {
      "nvim-tree/nvim-tree.lua",
      config = function()
        require("nvim-tree").setup({
          view = {
            width = 30,
            side = "left",
            mappings = {
              list = {
                { key = "v", action = "vsplit" },
                { key = "s", action = "split" },
                { key = "o", action = "edit" },
              },
            },
          },
        })
        vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
      end
    },

    -- Lualine
    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("lualine").setup({ options = { theme = "tokyonight" } })
      end
    },

    -- nvim-cmp (autouzupełnianie)
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lua",
        "saadparwaiz1/cmp_luasnip",
        "L3MON4D3/LuaSnip",
      },
      config = function()
        local cmp = require("cmp")
        cmp.setup({
          mapping = cmp.mapping.preset.insert({
            ["<Tab>"] = cmp.mapping.select_next_item(),
            ["<S-Tab>"] = cmp.mapping.select_prev_item(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
          }),
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "nvim_lua" },
            { name = "luasnip" },
            { name = "buffer" },
            { name = "path" },
          })
        })
      end
    },

    -- Snippet loader
    {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end
    },

    -- Treesitter
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = {
            "cpp", "c", "lua", "vim", "bash",
            "html", "css", "javascript", "typescript"
          },
          highlight = { enable = true },
          indent = { enable = true },
        })
      end
    },

    -- Neomake (kompilacja)
    {
      "neomake/neomake",
      config = function()
        vim.g.neomake_cpp_enabled_makers = { "clang++" }
        vim.g.neomake_open_list = 2
      end
    },

    -- Colorizer (kolory hex itd.)
    {
      "NvChad/nvim-colorizer.lua",
      config = function()
        require("colorizer").setup()
      end
    },

    -- Emmet (HTML/CSS)
    {
      "mattn/emmet-vim"
    },

    -- Komentowanie
    {
      "numToStr/Comment.nvim",
      config = function()
        require("Comment").setup()
      end
    },
})

