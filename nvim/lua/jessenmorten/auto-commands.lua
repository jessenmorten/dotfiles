local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
})

local term_group = vim.api.nvim_create_augroup("TermOpen", { clear = true })
vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
        vim.cmd("setlocal nonumber norelativenumber signcolumn=no")
        vim.cmd("startinsert")
    end,
    group = term_group,
    pattern = "*",
})
