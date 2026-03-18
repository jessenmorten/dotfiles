return {
    "goolord/alpha-nvim",
    event = "VimEnter",
    keys = {
        { "<leader>a", "<cmd>Alpha<CR>", desc = "Toggle Alpha" },
    },
    opts = function()
        local dashboard = require("alpha.themes.dashboard")
        local logo = [[
                        .8
                      .888
                    .8888'
                   .8888'
                   888'
                   8'
      .88888888888. .88888888888.
   .8888888888888888888888888888888.
 .8888888888888888888888888888888888.
.&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&'
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&'
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@:
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@:
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%.
`%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%.
 `00000000000000000000000000000000000'
  `000000000000000000000000000000000'
   `0000000000000000000000000000000'
     `###########################'
       `#######################'
         `#########''########'
           `""""""'  `"""""'
]]
        dashboard.section.header.val = vim.split(logo, "\n")

        dashboard.section.buttons.val = {
            dashboard.button("l", "📦 Lazy", ":Lazy<CR>"),
            dashboard.button("q", "❌ Quit", ":q<CR>"),
        }

        for _, button in ipairs(dashboard.section.buttons.val) do
            button.opts.hl = "AlphaButtons"
            button.opts.hl_shortcut = "AlphaShortcut"
        end

        dashboard.section.header.opts.hl = "AlphaHeader"
        dashboard.section.buttons.opts.hl = "AlphaButtons"
        dashboard.section.footer.opts.hl = "AlphaFooter"
        dashboard.opts.layout[1].val = 8

        -- default footer
        dashboard.section.footer.val = "🎉 Welcome back to Neovim!"

        return dashboard
    end,
    config = function(_, dashboard)
        require("alpha").setup(dashboard.opts)

        vim.api.nvim_create_autocmd("User", {
            pattern = "LazyVimStarted",
            callback = function()
                local stats = require("lazy").stats()
                local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                dashboard.section.footer.val = "🏁 " .. stats.count .. " plugins loaded in " .. ms .. "ms"
                pcall(vim.cmd.AlphaRedraw)
            end,
        })
    end,
}

