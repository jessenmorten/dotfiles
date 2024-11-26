return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("lualine").setup({
            options = {
                theme = "auto",
                section_separators = { left = "", right = "" },
                component_separators = { left = "", right = "" },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "filetype" },
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
                lualine_b = {{
                    "tabs",
                    mode = 1,
                    fmt = function(name, context)
                        local buflist = vim.fn.tabpagebuflist(context.tabnr)
                        local winnr = vim.fn.tabpagewinnr(context.tabnr)
                        local bufnr = buflist[winnr]

                        if vim.fn.getbufvar(bufnr, '&buftype') == 'terminal' then
                            return "terminal"
                        end

                        if name == "[No Name]" then
                            return vim.fn.getbufvar(bufnr, '&filetype')
                        end

                        return name
                    end,
                }},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {{
                    "branch",
                    icon = "",
                }},
                lualine_z = { "datetime" },
            },
        })
    end,
}
