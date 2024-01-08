local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("lazy").setup("jessenmorten.plugins", {})
vim.notify("Loaded plugins")

require("jessenmorten.options")
vim.notify("Loaded options")

require("jessenmorten.keymaps")
vim.notify("Loaded keymaps")

require("jessenmorten.auto-commands")
vim.notify("Loaded auto-commands")
