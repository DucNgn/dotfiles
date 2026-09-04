local THEME_MODE_FILE = vim.fn.expand("~/.local/state/theme-mode")

local function current_theme_mode()
  local mode_file = io.open(THEME_MODE_FILE, "r")
  if not mode_file then
    return "light"
  end

  local mode = mode_file:read("*l")
  mode_file:close()
  return mode == "dark" and "dark" or "light"
end

local theme_mode = current_theme_mode()

return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = theme_mode == "dark" and "night" or "day",
      styles = {
        comments = { italic = false },
      },
    },
  },

  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
      opts.colorscheme = "tokyonight-" .. (theme_mode == "dark" and "night" or "day")
      vim.o.background = theme_mode
    end,
  },
}
