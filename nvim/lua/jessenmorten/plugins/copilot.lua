return {
    "github/copilot.vim",
    lazy = true,
    cmd = "Copilot",
    event = { "BufWinEnter" },
    config = function()
        vim.g.copilot_filetypes = {
            markdown = true,
            yaml = true,
            gitcommit = true,
        }

        -- fix "tab claimed by another plugin" issue
        vim.g.copilot_assume_mapped = true
    end
}
