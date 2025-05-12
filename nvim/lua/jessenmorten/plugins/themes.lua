local transparent = true

return {
    {
        "sainnhe/gruvbox-material",
    },
    {
        "maxmx03/fluoromachine.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            local fm = require "fluoromachine"

            fm.setup {
                glow = true,
                theme = "fluoromachine",
                transparent = transparent,
            }
        end
    },
    {
        "navarasu/onedark.nvim",
        opts = {
            style = "deep",
            transparent = transparent,
        },
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = {
            custom_highlights = function(colors)
                return {
                    FloatBorder = {
                        fg = colors.red,
                    },
                }
            end,
            transparent_background = transparent,
            color_overrides = {
                mocha = {
                    base = "#0d0d1c",
                    mantle = "#0d0d1c",
                },
            },
            styles = {
                comments = { "italic" },
                conditionals = { "italic" },
                loops = { "bold" },
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
                telescope = true,
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
        },
    },
}
