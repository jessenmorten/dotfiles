vim.g.mapleader = ' '                               -- map leader
vim.g.maplocalleader = ' '                          -- map local leader

vim.keymap.set("n", "<C-d>", "<C-d>zz")             -- do 'zz' after each '<C-d>'
vim.keymap.set("n", "<C-u>", "<C-u>zz")             -- do 'zz' after each '<C-u>'
vim.keymap.set("i", "<C-c>", "<Esc>")               -- use <C-c> as <Esc>
vim.keymap.set("n", "<leader>sr", [[:%s/]])         -- search and replace

vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")        -- move selected line up TODO: fix multiline weirdness
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")        -- move selected line down TODO: fix multiline weirdness
