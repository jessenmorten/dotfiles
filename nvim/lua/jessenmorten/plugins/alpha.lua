return {
    "goolord/alpha-nvim",
    event = "VimEnter",
    keys = {
        { "<leader>a", "<cmd>Alpha<CR>", desc = "Toggle Alpha" },
    },
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
        require("alpha").setup(dashboard.opts)

        vim.api.nvim_create_autocmd("User", {
            pattern = "LazyVimStarted",
            callback = function()
                local stats = require("lazy").stats()
                local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                dashboard.section.footer.val = "⚡ Plugins loaded " .. stats.count .. " in " .. ms .. "ms"
                pcall(vim.cmd.AlphaRedraw)
            end,
        })
    end,
}
