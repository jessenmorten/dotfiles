local servers = {
    csharp_ls = {},
    gopls = {},
    rust_analyzer = {},
    ts_ls = {},
    lua_ls = {
        settings = {
            Lua = {
                completion = {
                    callSnippet = "Replace",
                },
            },
        },
    },
}

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        -- Automatically install LSPs and related tools to stdpath for Neovim
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        {
            "j-hui/fidget.nvim",
            opts = {
                notification = {
                    override_vim_notify = true,
                    view = {
                        stack_upwards = true,
                    },
                    window = {
                        winblend = 0,
                        align = "bottom",
                    },
                },
            },
        },
        { "folke/neodev.nvim", opts = {} },
    },
    config = function()
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { remap = false })

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
            callback = function(event)
                local tele = require("telescope.builtin")
                local opts = { buffer = event.buf, remap = false }

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
                vim.api.nvim_buf_create_user_command(event.buf, "Format", function(_)
                    vim.lsp.buf.format()
                    vim.api.nvim_command("w")
                end, { desc = "Format current buffer with LSP" })

                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if client and client.server_capabilities.documentHighlightProvider then
                    -- Highlight references of the word under cursor
                    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                        buffer = event.buf,
                        callback = vim.lsp.buf.document_highlight,
                    })

                    -- Clear references when cursor moves
                    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                        buffer = event.buf,
                        callback = vim.lsp.buf.clear_references,
                    })
                end

                if client then
                    vim.notify(client.name .. " attached to buffer")
                end
            end,
        })

        -- Extend capabilities to include completion capabilities
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

        -- Ensure the servers and tools above are installed
        require("mason").setup()
        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
            "stylua", -- Used to format Lua code
        })
        require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

        -- Round virtual text and float borders
        vim.diagnostic.config({
            virtual_text = {
                prefix = "●",
            },
            float = {
                border = "rounded",
            },
        })

        -- Rounded borders for hover and signature help
        local handlers = {
            ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
            ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
        }

        require("mason-lspconfig").setup({
            handlers = {
                function(server_name)
                    local server = servers[server_name] or {}
                    -- This handles overriding only values explicitly passed
                    -- by the server configuration above. Useful when disabling
                    -- certain features of an LSP (for example, turning off formatting for tsserver)
                    server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                    server.handlers = vim.tbl_deep_extend("force", {}, handlers, server.handlers or {})
                    require("lspconfig")[server_name].setup(server)
                end,
            },
        })

        local function set_sign_icons(opts)
            opts = opts or {}

            if vim.diagnostic.count then
                local ds = vim.diagnostic.severity
                local levels = {
                    [ds.ERROR] = "error",
                    [ds.WARN] = "warn",
                    [ds.INFO] = "info",
                    [ds.HINT] = "hint",
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
                    numhl = "",
                })
            end

            sign({ name = "error", hl = "DiagnosticSignError" })
            sign({ name = "warn", hl = "DiagnosticSignWarn" })
            sign({ name = "hint", hl = "DiagnosticSignHint" })
            sign({ name = "info", hl = "DiagnosticSignInfo" })
        end

        set_sign_icons({
            error = "",
            warn = "",
            hint = "",
            info = "",
        })
    end,
}
