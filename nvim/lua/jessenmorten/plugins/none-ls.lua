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
                ls.builtins.formatting.csharpier,
                ls.builtins.formatting.stylua,
                ls.builtins.formatting.prettierd,
            }
        })
    end
}
