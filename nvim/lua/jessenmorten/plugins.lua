-- copilot "tab claimed by another plugin" fix
vim.g.copilot_assume_mapped = true

-- catppuccin
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
        percentage = 0.5,
    },
    styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = {},
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
        notify = false,
        mini = false,
    },
})

-- set colorscheme
vim.cmd.colorscheme "catppuccin"

-- lualine
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

-- gitsigns
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

-- telescope setup
require('telescope').setup {
    defaults = {
        mappings = {
            i = {
                ['<C-u>'] = false,
                ['<C-d>'] = false,
            },
        },
    },
}

-- enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- telescope keymaps
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<C-p>', require("telescope.builtin").git_files, { desc = '[S]earch [G]it [F]iles' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>/', function()
    require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
    })
end, { desc = '[/] Fuzzily search in current buffer]' })

-- lsp
require('mason').setup()
local lsp = require("lsp-zero")
lsp.preset("recommended")

local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = require("cmp").mapping.select_prev_item({ behavior = require("cmp").SelectBehavior.Select }),
    ['<C-n>'] = require("cmp").mapping.select_next_item({ behavior = require("cmp").SelectBehavior.Select }),
    ['<C-y>'] = require("cmp").mapping.confirm({ select = true }),
    ['<CR>'] = require("cmp").mapping.confirm({ select = true }),
    ["<C-Space>"] = require("cmp").mapping.complete(),
})

cmp_mappings["<Tab>"] = nil
cmp_mappings["<S-Tab>"] = nil

lsp.setup_nvim_cmp({ mapping = cmp_mappings })

lsp.set_preferences({
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>gr", require('telescope.builtin').lsp_references, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols, opts)
    vim.keymap.set('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, opts)
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)

    -- create ':Format' command
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })
end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})

require("fidget").setup()
