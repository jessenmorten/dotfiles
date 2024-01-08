return {
    "j-hui/fidget.nvim",
    priority = 999,
    opts = {
        notification = {
            override_vim_notify = true,
            view = {
                stack_upwards = false,
            },
            window = {
                winblend = 0,
                align = "top",
            },
        },
    }
}
