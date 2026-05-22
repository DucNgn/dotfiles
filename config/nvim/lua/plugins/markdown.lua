return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
  ft = { "markdown" },
  build = "cd app && npm install",
  keys = {
    { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview (browser)" },
  },
  config = function()
    vim.g.mkdp_browser = ""       -- use system default browser
    vim.g.mkdp_open_to_the_world = 0
    vim.g.mkdp_auto_start = 0
    vim.g.mkdp_auto_close = 1
    vim.g.mkdp_preview_options = {
      disable_sync_scroll = 0,
    }
  end,
}
