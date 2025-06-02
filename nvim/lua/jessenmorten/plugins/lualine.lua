return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local function lsp_client()
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      if next(clients) == nil then return "" end

      if #clients > 1 then
        -- If there are multiple clients, return a list of their names
        local client_names = {}
        for _, client in ipairs(clients) do
          table.insert(client_names, client.name)
        end
        return table.concat(client_names, ", ")
      end

        -- If there's only one client, return its name
        return clients[1].name
    end

    require("lualine").setup({
      options = {
        theme = "auto",
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        globalstatus = true, -- optional: enables a single statusline
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { { "branch", icon = "" } },
        lualine_c = { "filename" },
        lualine_x = {
          { "diagnostics", sources = { "nvim_diagnostic" } },
          lsp_client,
        },
        lualine_y = { "encoding", "fileformat", "filetype" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = {},
        lualine_y = {},
        lualine_z = { "location" },
      },
      tabline = {
        lualine_a = {},
        lualine_b = {{
          "tabs",
          mode = 1,
          fmt = function(name, context)
            local buflist = vim.fn.tabpagebuflist(context.tabnr)
            local winnr = vim.fn.tabpagewinnr(context.tabnr)
            local bufnr = buflist[winnr]

            local buftype = vim.api.nvim_get_option_value("buftype", { buf = bufnr })
            if buftype == "terminal" then return "terminal" end

            if name == "[No Name]" then
              local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
              return filetype ~= "" and filetype or "untitled"
            end

            return name
          end,
        }},
        lualine_c = {},
        lualine_x = {},
        lualine_y = { "datetime" },
        lualine_z = {},
      },
    })
  end,
}

