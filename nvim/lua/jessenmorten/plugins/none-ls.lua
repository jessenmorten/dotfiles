return {
    "nvimtools/none-ls.nvim",
    event = "BufReadPost",
    config = function()
        local ls = require("null-ls")

        ls.setup({
            sources = {
                -- Code action
                ls.builtins.code_actions.gitsigns,

                -- Formatting
                ls.builtins.formatting.csharpier, -- TODO: Verify that it works
                ls.builtins.formatting.stylua, -- TODO: Verify that it works
            }
        })
    end
}
