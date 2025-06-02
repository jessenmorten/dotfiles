-- LSP servers and settings
local servers = {
    csharp_ls = {},
    eslint = {},
    gopls = {},
    rust_analyzer = {},
    ts_ls = {},
    lua_ls = {
        settings = {
            Lua = {
                completion = { callSnippet = "Replace" },
            },
        },
    },
}

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        {
            "j-hui/fidget.nvim",
            opts = {
                notification = {
                    override_vim_notify = true,
                    view = { stack_upwards = false },
                    window = { winblend = 0, align = "top", border = "rounded" },
                },
            },
        },
        { "folke/neodev.nvim", opts = {} },
    },

    config = function()
        -- LSP capabilities
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

        -- Install servers and tools
        require("mason").setup()
        local ensure_installed = vim.tbl_keys(servers)
        vim.list_extend(ensure_installed, { "stylua" })
        require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

        -- Diagnostics config
        vim.diagnostic.config({
            virtual_text = { prefix = "●" },
            float = { border = "rounded" },
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "",
                    [vim.diagnostic.severity.WARN] = "",
                    [vim.diagnostic.severity.INFO] = "",
                    [vim.diagnostic.severity.HINT] = "",
                },
            },
        })

        -- Floating preview border and max width override
        local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
        function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
            opts = opts or {}
            opts.border = opts.border or "rounded"
            local win_width = vim.api.nvim_win_get_width(0)
            opts.max_width = opts.max_width or math.floor(win_width * 0.7)
            return orig_util_open_floating_preview(contents, syntax, opts, ...)
        end

        -- Keymap bindings and on-attach behavior
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
            callback = function(event)
                local tele = require("telescope.builtin")
                local opts = { buffer = event.buf, remap = false }

                -- LSP keymaps
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, opts)

                -- Telescope LSP pickers
                vim.keymap.set("n", "gi", tele.lsp_implementations, opts)
                vim.keymap.set("n", "<leader>gr", tele.lsp_references, opts)
                vim.keymap.set("n", "<leader>ds", tele.lsp_document_symbols, opts)
                vim.keymap.set("n", "<leader>ws", tele.lsp_dynamic_workspace_symbols, opts)
                vim.keymap.set("n", "<leader>gt", tele.lsp_type_definitions, opts)

                -- :Format command for buffer
                vim.api.nvim_buf_create_user_command(event.buf, "Format", function()
                    vim.lsp.buf.format()
                    vim.api.nvim_command("w")
                end, { desc = "Format current buffer with LSP" })

                local client = vim.lsp.get_client_by_id(event.data.client_id)

                -- Highlight references if supported
                if client and client.server_capabilities.documentHighlightProvider then
                    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                        buffer = event.buf,
                        callback = vim.lsp.buf.document_highlight,
                    })
                    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                        buffer = event.buf,
                        callback = vim.lsp.buf.clear_references,
                    })
                end

                -- Semantic tokens if supported
                if client and client.server_capabilities.semanticTokensProvider then
                    vim.lsp.semantic_tokens.start(event.buf, client.id)
                end

                vim.notify(client.name .. " attached to buffer")
            end,
        })

        -- LSP server setup via mason-lspconfig
        require("mason-lspconfig").setup({
            automatic_enable = true,
            handlers = {
                function(server_name)
                    local server = servers[server_name] or {}
                    server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                    require("lspconfig")[server_name].setup(server)
                end,
            },
        })
    end,
}

