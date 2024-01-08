return {
    "github/copilot.vim",
    lazy = true,
    cmd = "Copilot",
    event = { "VeryLazy" },
    config = function()
        vim.g.copilot_filetypes = {
            markdown = true,
            yaml = true,
        }

        -- fix "tab claimed by another plugin" issue
        vim.g.copilot_assume_mapped = true
    end
}
