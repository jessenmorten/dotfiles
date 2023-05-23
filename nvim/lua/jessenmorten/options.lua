vim.opt.number = true                                                       -- show line numbers
vim.opt.relativenumber = true                                               -- show relative line numbers
vim.opt.tabstop = 4                                                         -- number of spaces that a <tab> in the file counts for
vim.opt.softtabstop = 4                                                     -- number of spaces that a <tab> counts for while performing editing operations
vim.opt.shiftwidth = 4                                                      -- number of spaces to use for each setop of (auto)indent
vim.opt.expandtab = true                                                    -- use the appropriate number of spaces to insert a <tab>
vim.opt.smartindent = true                                                  -- do smart autoindenting when starting a new line
vim.opt.wrap = false                                                        -- when off lines will not wrap and only part of long lines will be displayed
vim.opt.sidescroll = 5                                                      -- the minimal number of columns to scroll horizontally when 'wrap' option is off
vim.opt.list = true                                                         -- enable 'list' mode
vim.opt.listchars = "space:·,tab:»·,trail:·,nbsp:·,extends:»,precedes:«"    -- strings to use in 'list' mode
vim.opt.hlsearch = false                                                    -- when on, highlight all matches if there is a previous search pattern
vim.opt.ignorecase = true                                                   -- ignore case in search patterns
vim.opt.smartcase = true                                                    -- override the 'ignorecase' option if the search pattern contains upper case characters
vim.opt.updatetime = 250                                                    -- if this many milliseconds nothing is typed the swap file will be written to disk
vim.opt.signcolumn = "yes"                                                  -- whether or not to draw the signcolumn
vim.opt.cmdheight = 0                                                       -- hide command line when not in use

