-- setup nvim-tree
require("nvim-tree").setup({
    filters = {
        dotfiles = true,
        exclude = {
            ".github",
        },
    },
    update_focused_file = {
        enable = true,
        update_root = true,
    },
    diagnostics = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
        debounce_delay = 50,
        severity = {
            min = vim.diagnostic.severity.HINT,
            max = vim.diagnostic.severity.ERROR,
        },
        icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        },
    },
    modified = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
    }
})
