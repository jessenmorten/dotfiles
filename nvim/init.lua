-- OPTIONS
vim.opt.guicursor = ""
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.sidescroll = 5
vim.opt.list = true
vim.opt.listchars = "space:·,tab:»·,trail:·,nbsp:·,extends:»,precedes:«"
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 250
vim.opt.signcolumn = "yes"
vim.opt.laststatus = 2
vim.opt.completeopt = "menu,menuone"
vim.opt.termguicolors = true
vim.opt.showmode = false
vim.opt.sidescrolloff = 8
vim.opt.scrolloff = 8
vim.opt.wildmode = "longest:full,full"
vim.opt.shadafile = "NONE"
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- PACKS > PLENARY
vim.pack.add({
    { src = "https://github.com/nvim-lua/plenary.nvim" },
})

-- PACKS > CATPPUCCIN
vim.pack.add({
    { src = "https://github.com/catppuccin/nvim" },
})

require("catppuccin").setup({
    custom_highlights = function(colors)
        return {
            FloatBorder = {
                fg = colors.red,
            },
        }
    end,
    transparent_background = false,
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
        types = { "bold", "italic" },
        operators = {},
    },
    lsp_styles = {
        virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
            ok = { "italic" },
        },
        underlines = {
            errors = { "undercurl", "italic" },
            hints = { "undercurl" },
            warnings = { "undercurl", "italic" },
            information = { "undercurl" },
            ok = { "undercurl" },
        },
        inlay_hints = {
            background = true,
        },
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
})

vim.cmd.colorscheme("catppuccin-macchiato")

-- PACKS > LUALINE
vim.pack.add({
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
})

require("lualine").setup({
    options = {
        theme = "auto",
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        globalstatus = true, -- optional: enables a single statusline
    }
})

-- PACKS > FIDGET
vim.pack.add({
    { src = "https://github.com/j-hui/fidget.nvim" },
})

require("fidget").setup({
    notification = {
        override_vim_notify = true,
        view = { stack_upwards = false },
        window = { winblend = 0, align = "bottom", border = "rounded" },
    },
})

-- PACKS > MASON, NVIM-LSPCONFIG
vim.pack.add({
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
})

require("mason").setup()
require("mason-lspconfig").setup()

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            diagnostics = {
                globals = {
                    "vim",
                    "require",
                },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            },
        },
    },
})

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

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or "rounded"
    local win_width = vim.api.nvim_win_get_width(0)
    opts.max_width = opts.max_width or math.floor(win_width * 0.7)
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("custom-lsp-attach", { clear = true }),
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
        vim.keymap.set("n", "<leader>ih", function()
            local enabled = vim.lsp.inlay_hint.is_enabled()
            vim.lsp.inlay_hint.enable(not enabled)
        end, { desc = "Toggle inlay hints" })

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
            vim.lsp.semantic_tokens.enable(true);
        end

        vim.notify(client.name .. " attached to buffer")
    end,
})

-- PACKS > NONE-LS
vim.pack.add({
    { src = "https://github.com/nvimtools/none-ls.nvim" },
})

local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.code_actions.gitsigns,
        null_ls.builtins.formatting.csharpier,
    },
})

-- PACKS > NVIM-CMP
vim.pack.add({
    { src = "https://github.com/hrsh7th/nvim-cmp" },
    { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
    { src = "https://github.com/hrsh7th/cmp-buffer" },
    { src = "https://github.com/hrsh7th/cmp-path" },
})

local cmp = require("cmp")

cmp.setup({
    window = {
        completion = cmp.config.window.bordered({
            border = "rounded",
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
        }),
        documentation = cmp.config.window.bordered({
            border = "rounded",
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
        }),
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<CR>"]  = cmp.mapping.confirm({ select = false }),
        ["<C-Space>"] = cmp.mapping.complete(),
    }),
    sources = {
        -- { name = "copilot" },
        { name = "nvim_lsp" },
        -- { name = "luasnip" },
        { name = "path" },
        { name = "buffer" },
    },
})

-- PACKS > TELESCOPE
vim.pack.add({
    { src = "https://github.com/nvim-telescope/telescope.nvim" },
    { src = "https://github.com/nvim-telescope/telescope-file-browser.nvim" },
    { src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },
})

local telescope = require("telescope")
local telescope_themes = require("telescope.themes")

telescope.setup({
    extensions = {
        ["ui-select"] = { telescope_themes.get_cursor({}) },
        ["file_browser"] = { telescope_themes.get_cursor({}) }
    }
})

telescope.load_extension("file_browser")
telescope.load_extension("ui-select")

vim.keymap.set("n", "<leader>e",        ":Telescope file_browser path=%:p:h select_buffer=true<CR>",    { desc = "Open file browser" })
vim.keymap.set("n", "<leader>?",        ":Telescope oldfiles<cr>",                                      { desc = "List previously open files" })
vim.keymap.set("n", "<leader>sf",       ":Telescope find_files<cr>",                                    { desc = "Search for files" })
vim.keymap.set("n", "<leader>sg",       ":Telescope live_grep<cr>",                                     { desc = "Search for text" })
vim.keymap.set("n", "<leader>/",        ":Telescope current_buffer_fuzzy_find<cr>",                     { desc = "Search in current buffer" })
vim.keymap.set("n", "<leader>sb",       ":Telescope git_branches<cr>",                                  { desc = "Search git branches" })
vim.keymap.set("n", "<leader>sc",       ":Telescope git_commits<cr>",                                   { desc = "Search git commits" })
vim.keymap.set("n", "<leader>fc",       ":Telescope git_bcommits<cr>",                                  { desc = "Search git commits for current file" })
vim.keymap.set("n", "<leader>ss",       ":Telescope git_status<cr>",                                    { desc = "Git status" })
vim.keymap.set("n", "<C-p>",            ":Telescope git_files<cr>",                                     { desc = "Search git files" })
vim.keymap.set("n", "<leader><space>",  ":Telescope buffers<cr>",                                       { desc = "List open buffers" })
vim.keymap.set("n", "<leader>sd",       ":Telescope diagnostics<cr>",                                   { desc = "List diagnostics" })
vim.keymap.set("n", "<leader>pc",       ":Telescope command_history<cr>",                               { desc = "Command history" })

-- PACKS > FUGITIVE
vim.pack.add({
    { src = "https://github.com/tpope/vim-fugitive" },
})

-- PACKS > GITSIGNS
vim.pack.add({
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
})

require("gitsigns").setup({
    signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
    },
    signcolumn = true,
    current_line_blame = false,
    current_line_blame_opts = {
        delay = 0
    },
    preview_config = {
        border = 'rounded',
    },
})

-- KEYMAPS > WINDOW NAVIGATION
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })
vim.keymap.set("t", "<C-h>", "<Esc><C-w>h", { desc = "Go to left window", remap = true })
vim.keymap.set("t", "<C-j>", "<Esc><C-w>j", { desc = "Go to lower window", remap = true })
vim.keymap.set("t", "<C-k>", "<Esc><C-w>k", { desc = "Go to upper window", remap = true })
vim.keymap.set("t", "<C-l>", "<Esc><C-w>l", { desc = "Go to right window", remap = true })

-- KEYMAPS > CTRL-C
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("v", "<C-c>", "<Esc>")

-- KEYMAPS > BUFFER SCROLLING
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- KEYMAPS > SEARCH/REPLACE
vim.keymap.set("n", "<leader>sr", [[:%s/]])
vim.keymap.set("n", "<leader>rr", [[:%s/\<<C-r><C-w>\>//g<left><left>]])

-- KEYMAPS > TERMINAL
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- KEYMAPS > TABS
vim.keymap.set("n", "<C-b>c", "<cmd>tabnew<cr>", { desc = "Create new tab" })
vim.keymap.set("t", "<C-b>c", "<cmd>tabnew<cr>", { desc = "Create new tab" })

for i = 1, 9, 1 do
    vim.keymap.set("n", "<C-b>" .. i, "<cmd>tabnext " .. i .. "<cr>", { desc = "Go to tab " .. i })
    vim.keymap.set("t", "<C-b>" .. i, "<cmd>tabnext " .. i .. "<cr>", { desc = "Go to tab " .. i })
end

-- AUTOCOMMAND > HIGHLIGHT ON YANK
local highlight_group = vim.api.nvim_create_augroup("CustomYankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
})

-- AUTOCOMMAND > START INSERT ON TERMINAL OPEN
local term_group = vim.api.nvim_create_augroup("CustomTermOpen", { clear = true })
vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
        vim.cmd("setlocal nonumber norelativenumber signcolumn=no")
        vim.cmd("startinsert")
    end,
    group = term_group,
    pattern = "*",
})

-- AUTOCOMMAND > START INSERT ON TERMINAL BUFFER ENTER
local term_enter_group = vim.api.nvim_create_augroup("CustomTermEnter", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        if vim.bo.buftype == "terminal" then
            vim.cmd("startinsert")
        end
    end,
    group = term_enter_group,
    pattern = "*",
})

-- USERCOMMAND > OPEN SINGLE TERMINAL
vim.api.nvim_create_user_command("T", function()
    vim.cmd("split")
    vim.cmd("wincmd j")
    vim.cmd("resize 15")
    vim.cmd("term")
end, { nargs = 0 })

-- USERCOMMAND > OPEN DOUBLE TERMINAL
vim.api.nvim_create_user_command("TT", function()
    vim.cmd("split")
    vim.cmd("wincmd j")
    vim.cmd("resize 15")

    vim.cmd("wincmd v")
    vim.cmd("wincmd l")
    vim.cmd("term")
    vim.cmd("stopinsert")

    vim.cmd("wincmd h")
    vim.cmd("term")
end, { nargs = 0 })

-- USERCOMMAND > OPEN FLOATING TERMINAL
vim.api.nvim_create_user_command("TF", function()
    local bufname = "Floating Terminal"
    ShowFloat(bufname)
    vim.cmd("term")
end, { nargs = 0 })

-- FUNCTION > SHOW FLOAT
function ShowFloat(bufname)
    local width = vim.api.nvim_get_option_value("columns", {})
    local height = vim.api.nvim_get_option_value("lines", {})
    local win_width = math.floor(width * 0.8)
    local win_height = math.floor(height * 0.8)
    local row = math.floor((height - win_height) / 2)
    local col = math.floor((width - win_width) / 2)
    local opts = {
        relative = "editor",
        width = win_width,
        height = win_height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
        title = bufname,
        title_pos = "center",
    }

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_name(buf) == vim.fn.expand(bufname) then
            return vim.api.nvim_open_win(buf, true, opts)
        end
    end

    local buf = vim.api.nvim_create_buf(false, true)
    local _ = vim.api.nvim_open_win(buf, true, opts)

    vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
end

