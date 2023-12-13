local function bootstrap_lazy()
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable",
            lazypath,
        })
    end
    vim.opt.rtp:prepend(lazypath)

    -- Set `mapleader` before loading plugins to ensure correct mappings
    vim.g.mapleader = " "
    vim.g.maplocalleader = " "
end

local function setup_plugins()
    require("lazy").setup({
        -- COMMON DEPENDENCIES
        {
            "nvim-lua/plenary.nvim",
            lazy = true
        },
        {
            "nvim-tree/nvim-web-devicons",
            lazy = true
        },

        -- UI
        {
            "folke/trouble.nvim",
            dependencies = { "nvim-tree/nvim-web-devicons" },
            opts = {
                position = "bottom",
                height = 10, -- used if position is top or bottom
                width = 50,  -- used if position is left or right
            },
            keys = {
                { "<leader>t", "<cmd>TroubleToggle<cr>", desc = "Toggle trouble list" },
            }
        },
        {
            "goolord/alpha-nvim",
            event = "VimEnter",
            opts = function()
                local dashboard = require("alpha.themes.dashboard")
                local logo = [[

     ██╗███████╗███████╗███████╗███████╗███╗   ██╗
     ██║██╔════╝██╔════╝██╔════╝██╔════╝████╗  ██║
     ██║█████╗  ███████╗███████╗█████╗  ██╔██╗ ██║
██   ██║██╔══╝  ╚════██║╚════██║██╔══╝  ██║╚██╗██║
╚█████╔╝███████╗███████║███████║███████╗██║ ╚████║
 ╚════╝ ╚══════╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═══╝
                ]]

                dashboard.section.header.val = vim.split(logo, "\n")
                dashboard.section.buttons.val = {
                    dashboard.button("l", "󰒲 " .. " Lazy", ":Lazy<CR>"),
                    dashboard.button("q", " " .. " Quit", ":qa<CR>"),
                }
                for _, button in ipairs(dashboard.section.buttons.val) do
                    button.opts.hl = "AlphaButtons"
                    button.opts.hl_shortcut = "AlphaShortcut"
                end
                dashboard.section.header.opts.hl = "AlphaHeader"
                dashboard.section.buttons.opts.hl = "AlphaButtons"
                dashboard.section.footer.opts.hl = "AlphaFooter"
                dashboard.opts.layout[1].val = 8
                return dashboard
            end,
            config = function(_, dashboard)
                -- close Lazy and re-open when the dashboard is ready
                if vim.o.filetype == "lazy" then
                    vim.cmd.close()
                    vim.api.nvim_create_autocmd("User", {
                        pattern = "AlphaReady",
                        callback = function()
                            require("lazy").show()
                        end,
                    })
                end

                require("alpha").setup(dashboard.opts)

                vim.api.nvim_create_autocmd("User", {
                    pattern = "LazyVimStarted",
                    callback = function()
                        local stats = require("lazy").stats()
                        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                        dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
                        pcall(vim.cmd.AlphaRedraw)
                    end,
                })
            end,
        },
        {
            "catppuccin/nvim",
            lazy = true,
            name = "catppuccin",
            opts = {
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
                    mini = true,
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
                color_overrides = {
                    mocha = {
                        base = "#161622",
                        mantle = "#191926",
                    },
                }
            }
        },
        {
            "folke/todo-comments.nvim",
            event = { "BufReadPost", "BufNewFile" },
            config = true,
            keys = {
                { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
            },
        },
        {
            "rcarriga/nvim-notify",
            config = function()
                vim.notify = require("notify")
            end,
        },
        {
            "nvim-lualine/lualine.nvim",
            event = "VeryLazy",
            config = true,
            opts = {
                theme = "auto",
                globalstatus = true,
                icons_enabled = true,
                section_separators = { left = "", right = "" },
                component_separators = { left = "", right = "" },
            },
        },
        {
            "lukas-reineke/indent-blankline.nvim",
            event = { "BufReadPost", "BufNewFile" },
            main = "ibl",
            opts = {
                indent = { char = "│" },
                scope = { enabled = false },
            }
        },
        {
            "echasnovski/mini.indentscope",
            version = false, -- wait till new 0.7.0 release to put it back on semver
            event = { "BufReadPre", "BufNewFile" },
            opts = {
                -- symbol = "▏",
                symbol = "│",
                options = { try_as_border = true },
            },
            init = function()
                vim.api.nvim_create_autocmd("FileType", {
                    pattern = {
                        "help",
                        "alpha",
                        "dashboard",
                        "neo-tree",
                        "Trouble",
                        "lazy",
                        "mason",
                        "notify",
                        "toggleterm",
                        "lazyterm",
                    },
                    callback = function()
                        vim.b.miniindentscope_disable = true
                    end,
                })
            end,
        },

        -- Editor
        {
            "nvim-treesitter/nvim-treesitter",
            event = "BufReadPost",
            run = ":TSUpdate",
            config = function()
                require("nvim-treesitter.configs").setup({
                    ensure_installed = { "c_sharp", "javascript", "typescript", "rust", "go", "python" },
                    sync_install = false,
                    auto_install = true,
                    highlight = {
                        enable = true,
                        additional_vim_regex_highlighting = false,
                    },
                })
            end,
        },
        {
            "tpope/vim-fugitive",
            cmd = "Git",
        },
        {
            "github/copilot.vim",
            lazy = true,
            cmd = "Copilot",
            event = { "VeryLazy" },
            config = function()
                -- copilot "tab claimed by another plugin" fix
                vim.g.copilot_assume_mapped = true

                -- copilot filetypes
                vim.g.copilot_filetypes = {
                    markdown = true,
                    yaml = true,
                }
            end
        },
        {
            "lewis6991/gitsigns.nvim",
            event = { "BufReadPre", "BufNewFile" },
            opts = {
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
                    delay = 0
                },
            },
        },
        {
            "nvim-telescope/telescope.nvim",
            cmd = "Telescope",
            version = false, -- Telescope did only one release, so use HEAD for now
            keys = {
                { "<leader>?",       "<cmd>Telescope oldfiles<cr>",     desc = "List previously open files" },
                { "<leader>sf",      "<cmd>Telescope find_files<cr>",   desc = "Search for files" },
                { "<leader>sg",      "<cmd>Telescope live_grep<cr>",    desc = "Search for text" },
                { "<leader>sb",      "<cmd>Telescope git_branches<cr>", desc = "Search git branches" },
                { "<leader>sc",      "<cmd>Telescope git_commits<cr>",  desc = "Search git commits" },
                { "<leader>fc",      "<cmd>Telescope git_bcommits<cr>", desc = "Search git commits" },
                { "<leader>ss",      "<cmd>Telescope git_status<cr>",   desc = "Search git status" },
                { "<C-p>",           "<cmd>Telescope git_files<cr>",    desc = "Search git files" },
                { "<leader><space>", "<cmd>Telescope buffers<cr>",      desc = "List open buffers" },
                { "<leader>sd",      "<cmd>Telescope diagnostics<cr>",  desc = "List diagnostics" },
                { "<leader>pc",      "<cmd>Telescope command_history<cr>",  desc = "Command history" },
            },
            config = function()
                vim.keymap.set("n", "<leader>/", function()
                    require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
                        winblend = 10,
                        previewer = false,
                    })
                end, { desc = "Search in current buffer" })
            end
        },
        {
            "echasnovski/mini.pairs",
            event = "BufReadPost",
            opts = {},
        },
        {
            "numToStr/Comment.nvim",
            event = { "BufReadPost", "BufNewFile" },
            config = true,
        },

        -- LSP
        {
            "jose-elias-alvarez/null-ls.nvim",
            event = "BufReadPost",
            config = function()
                local null_ls = require("null-ls")

                null_ls.setup({
                    sources = {
                        null_ls.builtins.diagnostics.markdownlint,
                        null_ls.builtins.formatting.prettier,
                        null_ls.builtins.formatting.stylua,
                        null_ls.builtins.formatting.shfmt,
                    },
                })
            end,
        },
        {
            'VonHeikemen/lsp-zero.nvim',
            event = { "BufReadPost", "BufNewFile" },
            config = function()
                local lsp = require("lsp-zero")
                lsp.preset("recommended")

                local cmp_mappings = lsp.defaults.cmp_mappings({
                    ['<C-p>'] = require("cmp").mapping.select_prev_item({ behavior = require("cmp").SelectBehavior.Select }),
                    ['<C-n>'] = require("cmp").mapping.select_next_item({ behavior = require("cmp").SelectBehavior.Select }),
                    ['<C-y>'] = require("cmp").mapping.confirm({ select = true }),
                    ['<CR>'] = require("cmp").mapping.confirm({ select = false }),
                    ["<C-Space>"] = require("cmp").mapping.complete(),
                })

                cmp_mappings["<Tab>"] = nil
                cmp_mappings["<S-Tab>"] = nil

                lsp.setup_nvim_cmp({ mapping = cmp_mappings })

                lsp.set_sign_icons({
                    error = "",
                    warn = "",
                    hint = "",
                    info = "",
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
                        vim.api.nvim_command("w")
                    end, { desc = 'Format current buffer with LSP' })
                end)
                lsp.setup()

                vim.diagnostic.config({
                    virtual_text = true
                })

                local servers = {
                    gopls = {},
                    html = {},
                    lua_ls = {},
                    rust_analyzer = {},
                    marksman = {},
                    tsserver = {},
                    jsonls = {},
                    csharp_ls = {},
                    pyright = {},
                    clangd = {},
                }

                -- Ensure the servers above are installed
                require("mason-lspconfig").setup({ ensure_installed = vim.tbl_keys(servers) })
            end,
            dependencies = {
                { 'neovim/nvim-lspconfig' },
                { 'williamboman/mason.nvim' },
                { 'williamboman/mason-lspconfig.nvim' },

                -- autocompletion
                { 'hrsh7th/nvim-cmp' },
                { 'hrsh7th/cmp-buffer' },
                { 'hrsh7th/cmp-path' },
                { 'saadparwaiz1/cmp_luasnip' },
                { 'hrsh7th/cmp-nvim-lsp' },
                { 'hrsh7th/cmp-nvim-lua' },

                -- snippets
                { 'L3MON4D3/LuaSnip' },
                { 'rafamadriz/friendly-snippets' },

                -- other
                { 'j-hui/fidget.nvim' },
            }
        },
    })
end

local function set_options()
    vim.opt.guicursor = ""
    vim.opt.colorcolumn = "80"
    vim.opt.number = true -- show line numbers
    vim.opt.relativenumber = true -- show relative line numbers
    vim.opt.tabstop = 4 -- number of spaces that a <tab> in the file counts for
    vim.opt.softtabstop = 4 -- number of spaces that a <tab> counts for while performing editing operations
    vim.opt.shiftwidth = 4 -- number of spaces to use for each setop of (auto)indent
    vim.opt.expandtab = true -- use the appropriate number of spaces to insert a <tab>
    vim.opt.smartindent = true -- do smart autoindenting when starting a new line
    vim.opt.wrap = false -- when off lines will not wrap and only part of long lines will be displayed
    vim.opt.sidescroll = 5 -- the minimal number of columns to scroll horizontally when 'wrap' option is off
    vim.opt.list = true -- enable 'list' mode
    vim.opt.listchars = "space:·,tab:»·,trail:·,nbsp:·,extends:»,precedes:«" -- strings to use in 'list' mode
    vim.opt.hlsearch = false -- when on, highlight all matches if there is a previous search pattern
    vim.opt.ignorecase = true -- ignore case in search patterns
    vim.opt.smartcase = true -- override the 'ignorecase' option if the search pattern contains upper case characters
    vim.opt.updatetime = 250 -- if this many milliseconds nothing is typed the swap file will be written to disk
    vim.opt.signcolumn = "yes" -- whether or not to draw the signcolumn
    vim.opt.cmdheight = 0 -- hide command line when not in use
    vim.opt.laststatus = 0 -- always hide statusline
    vim.opt.completeopt = 'menuone,noselect' -- completion options
    vim.opt.termguicolors = true -- enable 24-bit RGB color in the TUI
    vim.opt.showmode = false -- Dont show mode since we have a statusline
    vim.opt.sidescrolloff = 8 -- Columns of context
    vim.opt.scrolloff = 8 -- Lines of context
    vim.opt.wildmode = "longest:full,full" -- Command-line completion mode
    vim.cmd.colorscheme "catppuccin"
end

local function set_keymaps()
    vim.keymap.set("n", "<C-d>", "<C-d>zz")     -- do 'zz' after each '<C-d>'
    vim.keymap.set("n", "<C-u>", "<C-u>zz")     -- do 'zz' after each '<C-u>'
    vim.keymap.set("i", "<C-c>", "<Esc>")       -- use <C-c> as <Esc> in insert mode
    vim.keymap.set("v", "<C-c>", "<Esc>")       -- use <C-c> as <Esc> in visual mode
    vim.keymap.set("n", "<leader>sr", [[:%s/]]) -- search and replace

    -- Move to window using the <ctrl> hjkl keys
    vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
    vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
    vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
    vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

    -- Resize window using <ctrl> arrow keys
    vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
    vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
    vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
    vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

    -- Move Lines
    vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
    vim.keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
    vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
    vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
    vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
    vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

    -- Clear buffers
    vim.keymap.set("n", "<leader>bc", "<cmd>%bd|e#|bd#<cr>", { desc = "Close other buffers" })

    -- Terminal
    vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

    -- Tabs
    vim.keymap.set("n", "<C-b>c", "<cmd>tabnew<cr>", { desc = "Create new tab" })
    vim.keymap.set("n", "<C-b>1", "<cmd>tabnext 1<cr>", { desc = "Go to tab 1" })
    vim.keymap.set("n", "<C-b>2", "<cmd>tabnext 2<cr>", { desc = "Go to tab 2" })
    vim.keymap.set("n", "<C-b>3", "<cmd>tabnext 3<cr>", { desc = "Go to tab 3" })
    vim.keymap.set("n", "<C-b>4", "<cmd>tabnext 4<cr>", { desc = "Go to tab 4" })
    vim.keymap.set("n", "<C-b>5", "<cmd>tabnext 5<cr>", { desc = "Go to tab 5" })

    vim.keymap.set("t", "<C-b>c", "<cmd>tabnew<cr>", { desc = "Create new tab" })
    vim.keymap.set("t", "<C-b>1", "<cmd>tabnext 1<cr>", { desc = "Go to tab 1" })
    vim.keymap.set("t", "<C-b>2", "<cmd>tabnext 2<cr>", { desc = "Go to tab 2" })
    vim.keymap.set("t", "<C-b>3", "<cmd>tabnext 3<cr>", { desc = "Go to tab 3" })
    vim.keymap.set("t", "<C-b>4", "<cmd>tabnext 4<cr>", { desc = "Go to tab 4" })
    vim.keymap.set("t", "<C-b>5", "<cmd>tabnext 5<cr>", { desc = "Go to tab 5" })
end

local function set_autocmds()
    -- highlight on yank
    local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
    vim.api.nvim_create_autocmd('TextYankPost', {
        callback = function()
            vim.highlight.on_yank()
        end,
        group = highlight_group,
        pattern = '*',
    })
end

bootstrap_lazy()
setup_plugins()
set_options()
set_keymaps()
set_autocmds()
