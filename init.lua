-- 📌 Automatyczna instalacja Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- 📌 Podstawowe ustawienia Neovim
vim.opt.number = true              -- Numery linii
vim.opt.relativenumber = true      -- Relatywne numery linii
vim.opt.tabstop = 4                -- Długość tabulacji
vim.opt.shiftwidth = 4             -- Wcięcia kodu
vim.opt.expandtab = true           -- Konwersja tabów na spacje
vim.opt.autoindent = true          -- Automatyczne wcięcia
vim.opt.termguicolors = true       -- Obsługa kolorów w terminalu
vim.opt.clipboard = "unnamedplus"  -- Schowek systemowy
vim.opt.cursorline = true          -- Podświetlenie linii kursora

-- 📌 Instalacja i konfiguracja pluginów
require("lazy").setup({

    { "github/copilot.vim" },

    {
    -- 🔧 LSP dla Rust (rust-analyzer)
      "neovim/nvim-lspconfig",
      config = function()
        require("lspconfig").rust_analyzer.setup({
          settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              checkOnSave = { command = "clippy" },
            }
          }
        })
      end
    },

    {
      -- 🔥 rust-tools.nvim dla lepszego wsparcia Rust
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
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" }, config = function()
        local telescope = require("telescope")
        telescope.setup({})
        vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>")
        vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>")
        vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>")
        vim.keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>")
    end },

    -- Zarządzanie LSP
    { "williamboman/mason.nvim", config = function()
        require("mason").setup()
    end },

    { "williamboman/mason-lspconfig.nvim", dependencies = { "mason.nvim" }, config = function()
        require("mason-lspconfig").setup({
            ensure_installed = { "clangd", "lua_ls", "pyright" }
        })
    end },

    -- 🔄 Automatyczne domykanie nawiasów
    { "windwp/nvim-autopairs", config = function()
        require("nvim-autopairs").setup({})
    end },

    -- 🎨 Motyw graficzny
    { "folke/tokyonight.nvim", config = function()
        vim.cmd("colorscheme tokyonight")
    end },

    -- 🗂️ Drzewo plików (NvimTree)
    { "nvim-tree/nvim-tree.lua", config = function()
        require("nvim-tree").setup({
            view = {
                width = 30,
                side = "left",
                mappings = {
                    list = {
                        -- Przypisanie do klawisza v (vsplit)
                        { key = "v", action = "vsplit" },

                        -- Przypisanie do klawisza s (split)
                        { key = "s", action = "split" },

                        -- Przypisanie do klawisza o (normalne otwarcie)
                        { key = "o", action = "edit" },
                    },
                },
            },
        })

        -- Toggle nvim-tree z <leader>e
        vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>") 
    end },

    -- ⚡ Statusline (lualine)
    { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("lualine").setup({ options = { theme = "tokyonight" } })
      end
    },

    -- 💡 LSP dla C++ (`clangd`)
    { "neovim/nvim-lspconfig", config = function()
        require("lspconfig").clangd.setup({})
    end },

    -- 🔠 Autouzupełnianie (`nvim-cmp`)
    { "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
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
                { name = "buffer" },
                { name = "path" },
            })
        })
      end
    },

    -- 📝 Drzewo składniowe (syntax highlighting)
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "cpp", "c", "lua", "vim", "bash" },
            highlight = { enable = true },
            indent = { enable = true },
        })
    end },

    -- 🛠️ Kompilowanie kodu C++ z Neomake
    { "neomake/neomake", config = function()
        vim.g.neomake_cpp_enabled_makers = { "clang++" }
        vim.g.neomake_open_list = 2  -- Otwórz okno z wynikami kompilacji
    end },
})

-- 🎮 Skróty klawiszowe dla LSP
vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>")

-- 🎮 Skróty klawiszowe dla Neomake
vim.keymap.set("n", "<leader>m", ":Neomake<CR>")  -- Uruchamia kompilację (Neomake)

vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })


