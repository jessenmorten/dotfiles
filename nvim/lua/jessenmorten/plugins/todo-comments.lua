return {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = true,
    keys = {
        { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" }
    },
}
