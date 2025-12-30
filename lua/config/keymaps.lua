-- Zredukowany plik keymaps.lua. Mapowania LSP są teraz w `plugins/lsp.lua` w funkcji on_attach.

-- 🎮 Skróty do nawigacji i okien
vim.keymap.set(
	"v",
	"<A-j>",
	":m '>+1<CR>gv=gv",
	{ noremap = true, silent = true, desc = "Przesuń zaznaczenie w dół" }
)
vim.keymap.set(
	"v",
	"<A-k>",
	":m '<-2<CR>gv=gv",
	{ noremap = true, silent = true, desc = "Przesuń zaznaczenie w górę" }
)

-- 🎮 Skróty dla diagnostyki LSP (pozostawione globalnie dla wygody)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Idź do poprzedniego błędu" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Idź do następnego błędu" })

-- 🎮 Skróty klawiszowe dla Copilot (teraz z copilot.lua)
vim.g.copilot_no_tab_map = true
vim.keymap.set("i", "<C-J>", function()
	require("copilot").accept_line()
end, {
	desc = "Copilot: Akceptuj całą linię",
	expr = true,
	replace_keycodes = false,
	silent = true,
})
