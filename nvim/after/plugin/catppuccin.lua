-- setup catppuccino theme
require("catppuccin").setup({
    flavour = "mocha",
    background = {
        light = "latte",
        dark = "mocha",
    },
    transparent_background = false,
    dim_inactive = {
        enabled = true,
        shade = "dark",
        percentage = 0.1,
    },
    styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = { "italic" },
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
        mini = false,
    },
    color_overrides = {
        mocha = {
            base = "#161622",
            mantle = "#191926",
        },
    }
})

-- load the colorscheme
vim.cmd.colorscheme "catppuccin"
