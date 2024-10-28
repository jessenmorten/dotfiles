return {
    {
        "github/copilot.vim",
        lazy = true,
        cmd = "Copilot",
        event = { "BufWinEnter" },
        config = function()
            vim.g.copilot_filetypes = {
                markdown = true,
                yaml = true,
                gitcommit = true,
            }

            -- fix "tab claimed by another plugin" issue
            vim.g.copilot_assume_mapped = true
        end
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        branch = "canary",
        -- build = "make tiktoken", -- Only on MacOS or Linux
        config = function()
            require("CopilotChat").setup({
                debug = false,
                window = {
                    layout = "horizontal",
                },
                mappings = {
                    close = {
                        normal = "q",
                        insert = "<esc>",
                    },
                    reset = {
                        normal = "<C-r>",
                        insert = "<C-r>",
                    },
                },
            })

            vim.keymap.set("v", "<leader>i", function()
                local actions = require("CopilotChat.actions")
                require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
            end)

            vim.keymap.set("n", "<leader>i", function()
                vim.cmd("CopilotChat")
            end)
        end,
    },
}
