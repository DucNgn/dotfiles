-- ********
-- Settings
-- ********

lvim.colorscheme = "rose-pine"
vim.g.rose_pine_variant = 'moon'

vim.opt.timeoutlen = 500
vim.opt.shortmess = vim.opt.shortmess + "I"
vim.opt.lazyredraw = true
vim.opt.relativenumber = true

lvim.format_on_save = true

lvim.builtin.alpha.active = false
lvim.builtin.project.active = false
lvim.builtin.telescope.defaults.prompt_prefix = " "
lvim.builtin.telescope.defaults.path_display.shorten = nil
lvim.builtin.telescope.pickers = {
  find_files = { find_command = { "fd", "--type=file", "--hidden", "--exclude", ".git" } },
}
lvim.builtin.terminal.active = true
lvim.builtin.treesitter.highlight.enabled = true
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "css",
  "javascript",
  "json",
  "lua",
  "python",
  "rust",
  "toml",
  "typescript",
  "yaml",
}


-- ***********
-- Keybindings
-- ***********

lvim.leader = "space"

vim.cmd("map 0 ^")
vim.cmd("nnoremap Q <nop>")
vim.cmd("nnoremap cc ddko")

vim.cmd("nnoremap j gj")
vim.cmd("nnoremap k gk")
vim.cmd("nnoremap <Leader>F <cmd>lua GrepInputString()<CR>")


lvim.keys.normal_mode["<Leader>bn"] = ":bnext<CR>"
lvim.keys.normal_mode["<Leader>bx"] = ":bp <BAR> bd #<CR>"

lvim.keys.visual_block_mode.J = false
lvim.keys.visual_block_mode.K = false

function GrepInputString()
  local default = vim.api.nvim_eval([[expand("<cword>")]])
  local input = vim.fn.input({
    prompt = "Search for: ",
    default = default,
  })
  require("telescope.builtin").grep_string({ search = input })
end

lvim.builtin.which_key.mappings["sT"] = { "<cmd>lua GrepInputString()<CR>", "Text under cursor" }
lvim.builtin.which_key.mappings["lo"] = { "<cmd>TSLspOrganize<CR>", "Organize imports" }
lvim.builtin.which_key.mappings["lI"] = { "<cmd>TSLspImportAll<CR>", "Import all" }
lvim.builtin.which_key.mappings["li"] = { "<cmd>TSLspImportCurrent<CR>", "Import under cursor" }

-- *******
-- Plugins
-- *******

lvim.plugins = {
  { "AndrewRadev/tagalong.vim" },
  {
    "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup { plugins = { tmux = { enabled = true } } }
    end
  },
  { "christoomey/vim-tmux-navigator" },
  { "editorconfig/editorconfig-vim" },
  { "farmergreg/vim-lastplace" },
  { "felipec/vim-sanegx", event = "BufRead" },
  { "fenetikm/falcon" },
  { "ggandor/lightspeed.nvim" },
  { "jose-elias-alvarez/nvim-lsp-ts-utils" },
  { "jxnblk/vim-mdx-js" },
  { "rose-pine/neovim" },
  { "tpope/vim-abolish" },
  { "tpope/vim-repeat" },
  { "tpope/vim-surround", keys = { "c", "d", "y" } },
  { "vim-test/vim-test" },
  {
    "npxbr/glow.nvim",
    ft = { "markdown" }
  },
}

-- ***
-- LSP
-- ***

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "tsserver" })

local lspconfig = require("lspconfig")

local tsserver_opts = {
  init_options = require("nvim-lsp-ts-utils").init_options,
  on_attach = function(client)
    local ts_utils = require("nvim-lsp-ts-utils")
    ts_utils.setup({})
    ts_utils.setup_client(client)
  end,
}
lspconfig["tsserver"].setup(tsserver_opts)

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { exe = "black", filetypes = { "python" } },
  { exe = "isort", filetypes = { "python" } },
  { exe = "prettierd" },
}

local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { exe = "flake8" },
  { exe = "eslint_d" },
}
