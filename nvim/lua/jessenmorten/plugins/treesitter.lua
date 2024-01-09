local ensure_installed = {
    "lua",
    "javascript",
    "typescript",
    "vim",
    "vimdoc",
}

return {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = ensure_installed,
            highlight = { enable = true },
            indent = { enable = true }
        })
    end,
}
