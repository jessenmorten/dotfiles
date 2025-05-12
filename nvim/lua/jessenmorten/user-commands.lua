vim.api.nvim_create_user_command("T", function()
    vim.cmd("split")
    vim.cmd("wincmd j")
    vim.cmd("resize 15")
    vim.cmd("term")
end, { nargs = 0 })

vim.api.nvim_create_user_command("TT", function()
    vim.cmd("split")
    vim.cmd("wincmd j")
    vim.cmd("resize 15")

    vim.cmd("wincmd v")
    vim.cmd("wincmd l")
    vim.cmd("term")
    vim.cmd("stopinsert")

    vim.cmd("wincmd h")
    vim.cmd("term")
end, { nargs = 0 })

vim.api.nvim_create_user_command("Note", function()
    local bufname = "Floating Note"
    ShowFloat(bufname)
    vim.cmd("edit " .. "~/nvim-note.md")
end, { nargs = 0 })

vim.api.nvim_create_user_command("TF", function()
    local bufname = "Floating Terminal"
    ShowFloat(bufname)
    vim.cmd("term")
end, { nargs = 0 })

function ShowFloat(bufname)
    local width = vim.api.nvim_get_option_value("columns", {})
    local height = vim.api.nvim_get_option_value("lines", {})
    local win_width = math.floor(width * 0.8)
    local win_height = math.floor(height * 0.8)
    local row = math.floor((height - win_height) / 2)
    local col = math.floor((width - win_width) / 2)
    local opts = {
        relative = "editor",
        width = win_width,
        height = win_height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
        title = bufname,
        title_pos = "center",
    }

    -- Check if the buffer already exists
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_name(buf) == vim.fn.expand(bufname) then
            -- If buffer exists, open it in a floating window
            return vim.api.nvim_open_win(buf, true, opts)
        end
    end

    -- Create a new buffer if it doesn't exist
    local buf = vim.api.nvim_create_buf(false, true)
    local _ = vim.api.nvim_open_win(buf, true, opts)

    -- Prevent buffer from being deleted when hidden
    vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
end

vim.api.nvim_create_user_command("S", function()
    local swap_map = {
        -- Boolean
        ["true"] = "false",
        ["false"] = "true",
        ["True"] = "False",
        ["False"] = "True",
        ["TRUE"] = "FALSE",
        ["FALSE"] = "TRUE",

        -- Emoij
        ["✅"] = "❌",
        ["❌"] = "✅",
    }

    local current_word = vim.fn.expand("<cword>")
    local replacement = swap_map[current_word]

    if replacement then
        vim.cmd("normal! ciw" .. replacement)
        vim.notify("Replaced: " .. current_word .. " with " .. replacement)
    else
        vim.notify("No replacement found for: " .. current_word, vim.log.levels.WARN)
    end
end, { nargs = 0 })
