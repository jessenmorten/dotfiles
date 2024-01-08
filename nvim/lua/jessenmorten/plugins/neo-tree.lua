return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        vim.keymap.set("n", "<C-n>", ":Neotree toggle<CR>", { desc = "Open Neotree" })

        require("neo-tree").setup({
            close_if_last_window = true,
            filesystem = {
                filtered_items = {
                    visible = true,
                },
                use_libuv_file_watcher = true,
                follow_current_file = {
                    enabled = true
                },
            },

        })
    end
}
