-- Plik dedykowany do formatowania kodu za pomocą conform.nvim
return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			-- Globalne ustawienia dla formatterów
			formatters = {
				["clang-format"] = {
					args = {
						"--style=" .. vim.json.encode({
							BasedOnStyle = "LLVM",
							IndentWidth = 4,
							TabWidth = 4,
							UseTab = "Never",
							ColumnLimit = 120,

							PointerAlignment = "Left",
							BreakBeforeBraces = "Custom",
							SortIncludes = false,

							BraceWrapping = {
								AfterClass = true,
								AfterFunction = true,
								AfterNamespace = true,
								AfterStruct = false,
								AfterEnum = false,
								AfterControlStatement = true,
								BeforeCatch = false,
								BeforeElse = false,
							},
						}),
					},
				},
			},

			-- Definicja, który formatter do jakiego pliku
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				vue = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				python = { "black" },
				rust = { "rustfmt" },
				c = { "clang-format" },
				cpp = { "clang-format" },
			},

			-- Włączenie formatowania przy zapisie
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
		},

		-- Funkcja 'init' na właściwym miejscu
		init = function()
			vim.keymap.set({ "n", "v" }, "<leader>f", function()
				require("conform").format({ async = true, lsp_fallback = true })
			end, { desc = "Formatuj plik lub zaznaczenie" })
		end,
	},
}
