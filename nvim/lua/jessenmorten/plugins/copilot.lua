return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = {
                    enabled = false,
                    auto_trigger = false,
                },
                panel = {
                    enabled = false,
                },
            })
        end,
    },
    {
        "zbirenbaum/copilot-cmp",
        config = function ()
            require("copilot_cmp").setup()
        end
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        branch = "main",
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
