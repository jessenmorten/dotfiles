-- setup lualine
require('lualine').setup {
    options = {
        theme = "auto",
        icons_enabled = true,
        component_separators = '|',
        section_separators = '',
        refresh = {
            statusline = 200,
            tabline = 500,
            winbar = 300
        },
    },
}
