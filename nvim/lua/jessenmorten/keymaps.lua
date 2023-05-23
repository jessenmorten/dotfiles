vim.g.mapleader = ' '                               -- map leader
vim.g.maplocalleader = ' '                          -- map local leader

vim.keymap.set("n", "<C-d>", "<C-d>zz")             -- do 'zz' after each '<C-d>'
vim.keymap.set("n", "<C-u>", "<C-u>zz")             -- do 'zz' after each '<C-u>'
vim.keymap.set("i", "<C-c>", "<Esc>")               -- use <C-c> as <Esc>
vim.keymap.set("n", "<leader>sr", [[:%s/]])          -- search and replace

