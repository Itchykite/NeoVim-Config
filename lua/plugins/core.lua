-- Plik na "rdzenne" wtyczki: interfejs, edycja, narzędzia
return {
  -- ===================================================================
  -- 1. Podstawa: Motyw i Interfejs
  -- ===================================================================
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd.colorscheme("tokyonight")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "tokyonight",
        globalstatus = true, -- Ujednolicony statusline dla wszystkich okien
      },
    },
  },

  -- ===================================================================
  -- 2. Edycja Tekstu: Autouzupełnianie, Komentarze, Kolory
  -- ===================================================================
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
  { "numToStr/Comment.nvim", opts = {} },
  { "NvChad/nvim-colorizer.lua", opts = {} },
  { "mattn/emmet-vim" }, -- Wciąż dobry wybór dla HTML/CSS

  -- NOWA WERSJA COPILOTA
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        -- Twoje skróty są respektowane przez ustawienia w keymaps.lua
        suggestion = { enabled = true, auto_trigger = true },
        panel = { enabled = true },
      })
    end,
  },

  -- ===================================================================
  -- 3. Drzewo Plików: Nvim-Tree
  -- ===================================================================
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local function on_attach(bufnr)
        local api = require("nvim-tree.api")
        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end
        local map = vim.keymap.set
        map("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
        map("n", "s", api.node.open.horizontal, opts("Open: Horizontal Split"))
        map("n", "<CR>", api.node.open.edit, opts("Open: Edit"))
      end

      require("nvim-tree").setup({
        on_attach = on_attach,
        view = { width = 30, side = "left" },
        actions = { open_file = { window_picker = { enable = false } } },
        renderer = { icons = { show = { file = true, folder = true, folder_arrow = true, git = true } } },
      })
      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle File Explorer" })
    end,
  },

  -- ===================================================================
  -- 4. Wyszukiwanie: Telescope
  -- ===================================================================
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({})
      vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find Files" })
      vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Live Grep" })
      vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Find Buffers" })
      vim.keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>", { desc = "Find Help Tags" })
    end,
  },

  -- ===================================================================
  -- 5. Podświetlanie Składni: Treesitter
  -- ===================================================================
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    -- Lazy.nvim automatycznie wywoła require("nvim-treesitter.configs").setup(opts)
    -- Nie potrzebujemy już ręcznej funkcji 'config'.
    opts = {
      ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "bash", "html", "css", "javascript", "typescript", "java", "rust" },
      highlight = { enable = true },
      indent = { enable = true },
      -- Dodajmy to, aby parsery instalowały się automatycznie przy otwarciu nowego typu pliku
      auto_install = true,
    },
  },
  -- ===================================================================
  -- 6. Integracja z GIT
  -- ===================================================================
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {}, -- Użyj domyślnych opcji, są świetne
  },
}

