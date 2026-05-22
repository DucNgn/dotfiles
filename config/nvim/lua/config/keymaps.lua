-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
-- Map jk to escape in insert mode
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode with jk" })

-- Search word under cursor (partial match, no word boundaries)
vim.keymap.set("n", "<leader>sW", function()
  require("snacks").picker.grep({ search = vim.fn.expand("<cword>") })
end, { desc = "Search word (partial)" })

-- Search visually selected text
vim.keymap.set("v", "<leader>sw", function()
  local text = vim.fn.getreg("v")
  require("snacks").picker.grep({ search = text })
end, { desc = "Search selection" })
