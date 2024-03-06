local ensure_installed = {
    "lua_ls",
    "tsserver",
    "gopls",
    "csharp_ls",
}

local handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
}

local function set_sign_icons(opts)
    opts = opts or {}

    if vim.diagnostic.count then
        local ds = vim.diagnostic.severity
        local levels = {
            [ds.ERROR] = "error",
            [ds.WARN] = "warn",
            [ds.INFO] = "info",
            [ds.HINT] = "hint"
        }

        local text = {}

        for i, l in pairs(levels) do
            if type(opts[l]) == "string" then
                text[i] = opts[l]
            end
        end

        vim.diagnostic.config({ signs = { text = text } })
        return
    end

    local sign = function(args)
        if opts[args.name] == nil then
            return
        end

        vim.fn.sign_define(args.hl, {
            texthl = args.hl,
            text = opts[args.name],
            numhl = ""
        })
    end

    sign({ name = "error", hl = "DiagnosticSignError" })
    sign({ name = "warn", hl = "DiagnosticSignWarn" })
    sign({ name = "hint", hl = "DiagnosticSignHint" })
    sign({ name = "info", hl = "DiagnosticSignInfo" })
end

local on_attach = function(client, bufnr)
    vim.notify("Attached " .. client.name, 2)
    local tele = require("telescope.builtin")
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)

    vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, opts)

    vim.keymap.set("n", "gi", tele.lsp_implementations, opts)
    vim.keymap.set("n", "<leader>gr", tele.lsp_references, opts)
    vim.keymap.set("n", "<leader>ds", tele.lsp_document_symbols, opts)
    vim.keymap.set("n", "<leader>ws", tele.lsp_dynamic_workspace_symbols, opts)
    vim.keymap.set("n", "<leader>gt", tele.lsp_type_definitions, opts)

    -- create ":Format" command
    vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
        vim.lsp.buf.format()
        vim.api.nvim_command("w")
    end, { desc = "Format current buffer with LSP" })
end

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "nvim-telescope/telescope-ui-select.nvim",
        "j-hui/fidget.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
    },
    event = { "BufReadPost" },
    config = function()
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = ensure_installed,
        })
        local lsp_config = require("lspconfig")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { remap = false })

        vim.diagnostic.config({
            virtual_text = {
                prefix = "●",
            },
            float = {
                border = "rounded"
            },
        })

        set_sign_icons({
            error = "",
            warn = "",
            hint = "",
            info = "",
        })

        for _, server in ipairs(ensure_installed) do
            lsp_config[server].setup({
                capabilities = capabilities,
                on_attach = on_attach,
                handlers = handlers,
            })
        end
    end,
}
