return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        tag = "0.1.5",
        cmd = "Telescope",
        lazy = false,
        keys = {
            { "<leader>?",       "<cmd>Telescope oldfiles<cr>",         desc = "List previously open files" },
            { "<leader>sf",      "<cmd>Telescope find_files<cr>",       desc = "Search for files" },
            { "<leader>sg",      "<cmd>Telescope live_grep<cr>",        desc = "Search for text" },
            { "<leader>sb",      "<cmd>Telescope git_branches<cr>",     desc = "Search git branches" },
            { "<leader>sc",      "<cmd>Telescope git_commits<cr>",      desc = "Search git commits" },
            { "<leader>fc",      "<cmd>Telescope git_bcommits<cr>",     desc = "Search git commits" },
            { "<leader>ss",      "<cmd>Telescope git_status<cr>",       desc = "Search git status" },
            { "<C-p>",           "<cmd>Telescope git_files<cr>",        desc = "Search git files" },
            { "<leader><space>", "<cmd>Telescope buffers<cr>",          desc = "List open buffers" },
            { "<leader>sd",      "<cmd>Telescope diagnostics<cr>",      desc = "List diagnostics" },
            { "<leader>pc",      "<cmd>Telescope command_history<cr>",  desc = "Command history" },
        },
        config = function()
            local builtin = require("telescope.builtin")
            local themes = require("telescope.themes")

            vim.keymap.set("n", "<leader>/", function()
                builtin.current_buffer_fuzzy_find(themes.get_dropdown {
                    winblend = 0, -- set to 10 when not transparent
                    previewer = false,
                })
            end, { desc = "Search in current buffer" })
        end
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
            require("telescope").setup {
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown {}
                    }
                }
            }

            -- To get ui-select loaded and working with telescope, you need to call
            -- load_extension, somewhere after setup function:
            require("telescope").load_extension("ui-select")
        end
    },
}
