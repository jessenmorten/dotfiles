return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("lualine").setup {
            options = {
                theme = "auto",
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = { "filename" },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = { "filename" },
            },
            tabline = {
                lualine_a = {},
                lualine_b = {
                    {
                        "tabs",
                        mode = 2,
                    }
                },
                lualine_c = {},
                lualine_x = {},
                lualine_y = { "branch" },
                lualine_z = { "datetime" }
            },
        }
    end
}
