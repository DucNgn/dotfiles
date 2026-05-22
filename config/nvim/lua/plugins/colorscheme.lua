local function current_mode()
  local f = io.open(os.getenv("HOME") .. "/.config/theme-mode", "r")
  if not f then
    return "dark"
  end
  local mode = f:read("*l"):gsub("%s+", "")
  f:close()
  return mode
end

return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
  },

  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
      local mode = current_mode()
      opts.colorscheme = mode == "light" and "washi" or "kanagawa-dragon"
      vim.o.background = mode == "light" and "light" or "dark"
    end,
  },
  -- Auto-reload theme when theme-mode file changes
  {
    "rktjmp/fwatch.nvim",
    config = function()
      require("fwatch").watch(os.getenv("HOME") .. "/.config/theme-mode", {
        on_event = function()
          vim.schedule(function()
            local m = current_mode()
            vim.o.background = m == "light" and "light" or "dark"
            local s = m == "light" and "washi" or "kanagawa-dragon"
            vim.cmd("colorscheme " .. s)
          end)
        end,
      })
    end,
  },
}
