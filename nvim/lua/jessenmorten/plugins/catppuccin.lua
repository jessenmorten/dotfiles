local transparent = false

return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    enabled = true,
    config = function()
        local opts = {
            flavour = "mocha",
            custom_highlights = function(colors)
                return {
                    FloatBorder = { fg = colors.yellow },
                }
            end,
            background = {
                light = "latte",
                dark = "mocha",
            },
            transparent_background = transparent,
            styles = {
                comments = { "italic" },
                conditionals = { "italic" },
                loops = {},
                functions = { "italic", "bold" },
                keywords = {},
                strings = {},
                variables = {},
                numbers = {},
                booleans = {},
                properties = {},
                types = {},
                operators = {},
            },
            integrations = {
                cmp = true,
                gitsigns = true,
                nvimtree = true,
                telescope = true,
                notify = true,
                mini = true,
                fidget = true,
                native_lsp = {
                    enabled = true,
                    underlines = {
                        errors = { "undercurl" },
                        hints = { "undercurl" },
                        warnings = { "undercurl" },
                        information = { "undercurl" },
                    },
                },
            },
        }

        if not transparent then
            opts.dim_inactive = {
                enabled = true,
                shade = "light",
                percentage = 0.1,
            }
            opts.color_overrides = {
                mocha = {
                    base = "#0d0d1c",
                    mantle = "#191926",
                },
            }
        end

        require("catppuccin").setup(opts)
        vim.cmd.colorscheme("catppuccin")
    end
}
