-- setup gitsigns
require("gitsigns").setup {
    signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
    },
    signcolumn = true,
    current_line_blame = true,
    current_line_blame_opts = {
        delay = 100
    },
}
