local highlight_group = vim.api.nvim_create_augroup("CustomYankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
})

local term_group = vim.api.nvim_create_augroup("CustomTermOpen", { clear = true })
vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
        vim.cmd("setlocal nonumber norelativenumber signcolumn=no")
        vim.cmd("startinsert")
    end,
    group = term_group,
    pattern = "*",
})

local term_enter_group = vim.api.nvim_create_augroup("CustomTermEnter", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        if vim.bo.buftype == "terminal" then
            vim.cmd("startinsert")
        end
    end,
    group = term_enter_group,
    pattern = "*",
})

local term_close_group = vim.api.nvim_create_augroup("CustomTermClose", { clear = true })
vim.api.nvim_create_autocmd("TermClose", {
    callback = function()
        vim.api.nvim_buf_delete(0, {force = true})
    end,
    group = term_close_group,
    pattern = "*",
})
