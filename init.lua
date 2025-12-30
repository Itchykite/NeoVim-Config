-- 📌 Automatyczna instalacja Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 📌 Ładowanie podstawowych ustawień
require("config.settings")
require("config.keymaps")

-- 📌 KLUCZOWA ZMIANA: Konfiguracja i ładowanie wtyczek z lazy.nvim
-- Lazy.nvim jest instruowany, aby załadować wszystkie pliki .lua z katalogu 'lua/plugins'
require("lazy").setup("plugins", {
  -- Możesz tu dodać opcje dla lazy.nvim, np.
  change_detection = {
    notify = false, -- nie pokazuj okienka przy każdej zmianie
  },
})

-- Koniec konfiguracji. Nic więcej nie jest potrzebne.
