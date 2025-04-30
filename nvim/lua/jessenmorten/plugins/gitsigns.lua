return {
    "lewis6991/gitsigns.nvim",
    version = "v1.0.2",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        signs = {
            add = { text = "+" },
            change = { text = "~" },
            delete = { text = "_" },
            topdelete = { text = "‾" },
            changedelete = { text = "~" },
        },
        signcolumn = true,
        current_line_blame = false,
        current_line_blame_opts = {
            delay = 0
        },
    },
}
