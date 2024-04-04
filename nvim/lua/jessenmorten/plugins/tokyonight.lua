return {
    "folke/tokyonight.nvim",
    priority = 1000,
    enabled = true,
    init = function()
        vim.cmd.colorscheme("tokyonight-night")
        vim.cmd.hi("Comment gui=none")
    end,
}
