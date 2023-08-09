-- setup lsp
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
    vim.keymap.set("n", "gi", require("telescope.builtin").lsp_implementations, opts)
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

local servers = {
    gopls = {},
    html = {},
    csharp_ls = {},
    lua_ls = {},
    ruff_lsp = {},
    rust_analyzer = {},
    tsserver = {},
    jsonls = {},
}

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'
mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
}
