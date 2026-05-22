return {
  {
    "stevearc/oil.nvim",
    dependencies = { "mini.icons" },
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
    },
    opts = {
      default_file_explorer = false,
    },
  },
}
