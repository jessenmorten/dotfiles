return {
    "goolord/alpha-nvim",
    event = "VimEnter",
    keys = {
        { "<leader>a", "<cmd>Alpha<CR>", desc = "Toggle Alpha" },
    },
    opts = function()
        local dashboard = require("alpha.themes.dashboard")
        local logo = [[
NNNNNNNN        NNNNNNNN                                                              iiii                          
N:::::::N       N::::::N                                                             i::::i                         
N::::::::N      N::::::N                                                              iiii                          
N:::::::::N     N::::::N                                                                                            
N::::::::::N    N::::::N    eeeeeeeeeeee       ooooooooooo vvvvvvv           vvvvvvviiiiiii    mmmmmmm    mmmmmmm   
N:::::::::::N   N::::::N  ee::::::::::::ee   oo:::::::::::oov:::::v         v:::::v i:::::i  mm:::::::m  m:::::::mm 
N:::::::N::::N  N::::::N e::::::eeeee:::::eeo:::::::::::::::ov:::::v       v:::::v   i::::i m::::::::::mm::::::::::m
N::::::N N::::N N::::::Ne::::::e     e:::::eo:::::ooooo:::::o v:::::v     v:::::v    i::::i m::::::::::::::::::::::m
N::::::N  N::::N:::::::Ne:::::::eeeee::::::eo::::o     o::::o  v:::::v   v:::::v     i::::i m:::::mmm::::::mmm:::::m
N::::::N   N:::::::::::Ne:::::::::::::::::e o::::o     o::::o   v:::::v v:::::v      i::::i m::::m   m::::m   m::::m
N::::::N    N::::::::::Ne::::::eeeeeeeeeee  o::::o     o::::o    v:::::v:::::v       i::::i m::::m   m::::m   m::::m
N::::::N     N:::::::::Ne:::::::e           o::::o     o::::o     v:::::::::v        i::::i m::::m   m::::m   m::::m
N::::::N      N::::::::Ne::::::::e          o:::::ooooo:::::o      v:::::::v        i::::::im::::m   m::::m   m::::m
N::::::N       N:::::::N e::::::::eeeeeeee  o:::::::::::::::o       v:::::v         i::::::im::::m   m::::m   m::::m
N::::::N        N::::::N  ee:::::::::::::e   oo:::::::::::oo         v:::v          i::::::im::::m   m::::m   m::::m
NNNNNNNN         NNNNNNN    eeeeeeeeeeeeee     ooooooooooo            vvv           iiiiiiiimmmmmm   mmmmmm   mmmmmm
]]
        dashboard.section.header.val = vim.split(logo, "\n")
        dashboard.section.buttons.val = {
            -- Note
            dashboard.button("n", "📝 " .. " Note", ":e ~/nvim-note.md<CR>"),

            -- Lazy
            dashboard.button("l", "📦 " .. " Lazy", ":Lazy<CR>"),

            -- Quit
            dashboard.button("q", "❌ " .. " Quit", ":q<CR>"),
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
