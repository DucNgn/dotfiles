return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      texlab = {
        settings = {
          texlab = {
            build = { onSave = true },
            forwardSearch = {
              executable = "displayline",
              args = { "-reuse-instance", "%l", "%p", "%f" },
            },
          },
        },
      },
    },
  },
}
