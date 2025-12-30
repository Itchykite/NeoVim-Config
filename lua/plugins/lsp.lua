-- Dedykowany plik dla całej konfiguracji LSP, nvim-cmp i powiązanych wtyczek
return {
  -- ===================================================================
  -- 7. KLUCZOWY BLOK: LSP (Language Server Protocol)
  -- ===================================================================
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Zarządzanie serwerami LSP
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",

      -- Uzupełnianie Kodu
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      -- Pobierz zdolności klienta (Neovim) z nvim-cmp
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Funkcja uruchamiana przy starcie każdego serwera LSP (on_attach)
      -- Tutaj definiujemy skróty klawiszowe, które będą działać tylko w buforach z LSP
      local on_attach = function(client, bufnr)
        local map = vim.keymap.set
        local opts = { buffer = bufnr, noremap = true, silent = true }
        -- Twoje skróty, teraz w prawidłowym miejscu
        map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "LSP: Idź do definicji" }))
        map("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "LSP: Pokaż referencje" }))
        map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "LSP: Dokumentacja" }))
        map("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "LSP: Akcje kodu" }))
        map("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "LSP: Zmień nazwę" }))
      end

      -- Inicjalizacja Mason, który zarządza instalacją serwerów
      require("mason").setup()

      -- NOWOCZESNY SPOSÓB:
      -- Użyj mason-lspconfig, aby automatycznie konfigurować serwery.
      -- Nie ma już potrzeby ręcznej pętli i listy 'servers'.
      require("mason-lspconfig").setup({
        -- Lista serwerów, które Mason ma automatycznie zainstalować.
        -- Możesz dodawać/usuwać nazwy wg potrzeb.
        ensure_installed = {
          "clangd",
          "pyright",
          "html",
          "cssls",
          "jdtls",
          "ts_ls", 
          "rust_analyzer",
          "lua_ls",
        },
        -- Ta funkcja zostanie wywołana dla każdego serwera z listy `ensure_installed`
        -- oraz dla każdego innego serwera, który zainstalujesz ręcznie przez Mason.
        handlers = {
          function(server_name) -- Domyślny handler
            require("lspconfig")[server_name].setup({
              on_attach = on_attach,
              capabilities = capabilities,
            })
          end,

          -- Specjalne ustawienia dla konkretnych serwerów
          ["lua_ls"] = function()
            require("lspconfig").lua_ls.setup({
              on_attach = on_attach,
              capabilities = capabilities,
              settings = {
                Lua = {
                  runtime = { version = "LuaJIT" },
                  diagnostics = { globals = { "vim" } },
                  workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                },
              },
            })
          end,

          ["rust_analyzer"] = function()
            require("lspconfig").rust_analyzer.setup({
              on_attach = on_attach,
              capabilities = capabilities,
              settings = {
                ["rust-analyzer"] = {
                  cargo = { allFeatures = true },
                  checkOnSave = { command = "clippy" },
                },
              },
            })
          end,
        },
      })

      -- Konfiguracja autouzupełniania (nvim-cmp)
      local cmp = require("cmp")
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
}
