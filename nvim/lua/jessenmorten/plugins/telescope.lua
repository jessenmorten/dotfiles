return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
        },
        cmd = "Telescope",
        lazy = false,
        keys = {
            { "<leader>?",       "<cmd>Telescope oldfiles<cr>",         desc = "List previously open files" },
            { "<leader>sf",      "<cmd>Telescope find_files<cr>",       desc = "Search for files" },
            { "<leader>sg",      "<cmd>Telescope live_grep<cr>",        desc = "Search for text" },
            { "<leader>sb",      "<cmd>Telescope git_branches<cr>",     desc = "Search git branches" },
            { "<leader>sc",      "<cmd>Telescope git_commits<cr>",      desc = "Search git commits" },
            { "<leader>fc",      "<cmd>Telescope git_bcommits<cr>",     desc = "Search git commits for current file" },
            { "<leader>ss",      "<cmd>Telescope git_status<cr>",       desc = "Git status" },
            { "<C-p>",           "<cmd>Telescope git_files<cr>",        desc = "Search git files" },
            { "<leader><space>", "<cmd>Telescope buffers<cr>",          desc = "List open buffers" },
            { "<leader>sd",      "<cmd>Telescope diagnostics<cr>",      desc = "List diagnostics" },
            { "<leader>pc",      "<cmd>Telescope command_history<cr>",  desc = "Command history" },
        },
        config = function()
            local telescope = require("telescope")
            local builtin = require("telescope.builtin")
            local themes = require("telescope.themes")

            telescope.setup({
                extensions = {
                    ["ui-select"] = {
                        themes.get_cursor({})
                    }
                }
            })

            telescope.load_extension("ui-select")

            vim.keymap.set("n", "<leader>/", function()
                builtin.current_buffer_fuzzy_find(themes.get_dropdown {
                    winblend = 0,
                    previewer = false,
                })
            end, { desc = "Search in current buffer" })
        end,
    },
}

