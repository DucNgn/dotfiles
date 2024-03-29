-- general
lvim.reload_config_on_save = false
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.lint_on_save = true
vim.opt.lazyredraw = true
vim.opt.relativenumber = true
lvim.builtin.terminal.shell = "/bin/zsh"

-- theme
vim.termguicolors = true

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"

lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
lvim.keys.normal_mode["<S-x>"] = ":bp <BAR> bd #<CR>"
lvim.keys.normal_mode["Q"] = "<nop>"

lvim.keys.insert_mode["kj"] = "<Esc>"
lvim.keys.insert_mode["jk"] = "<Esc>"

lvim.keys.visual_block_mode.J = false
lvim.keys.visual_block_mode.K = false

-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

-- Treesitter
lvim.builtin.treesitter.ensure_installed = {
  "javascript",
  "typescript",
  "json",
  "lua",
  "python",
  "tsx",
  "css",
  "rust",
  "java",
  "yaml",
  "latex"
}
lvim.builtin.treesitter.highlight.enable = true
lvim.builtin.telescope.pickers.find_files.previewer = nil

-- LSP
lvim.lsp.automatic_servers_installation = false

-- Formatters and Linters
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
  {
    exe = "black",
    filetypes = { "python" },
    args = { "--quiet", "--fast", "-" },
  },
  {
    exe = "rustfmt",
    filetype = { "rust" },
  },
  { exe = "gofmt", filetypes = { "go" } },
  { exe = "stylua", filetypes = { "lua" } },
})

local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
  { exe = "flake8" },
})

-- Plugins
lvim.plugins = {
  {
    "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup {
        window = {
          options = {
            number = false,
            cursorcolumn = false,
          }
        },
        plugins = { tmux = { enabled = true } }

      }
    end
  },
  {
    "phaazon/hop.nvim",
    event = "BufRead",
    config = function()
      require("hop").setup()
      vim.api.nvim_set_keymap("n", "s", ":HopChar2<cr>", { silent = true })
      vim.api.nvim_set_keymap("n", "S", ":HopWord<cr>", { silent = true })
    end,
  },
  {
    "itchyny/vim-cursorword",
    event = { "BufEnter", "BufNewFile" },
    config = function()
      vim.api.nvim_command("augroup user_plugin_cursorword")
      vim.api.nvim_command("autocmd!")
      vim.api.nvim_command("autocmd FileType NvimTree,lspsagafinder,dashboard,vista let b:cursorword = 0")
      vim.api.nvim_command("autocmd WinEnter * if &diff || &pvw | let b:cursorword = 0 | endif")
      vim.api.nvim_command("autocmd InsertEnter * let b:cursorword = 0")
      vim.api.nvim_command("autocmd InsertLeave * let b:cursorword = 1")
      vim.api.nvim_command("augroup END")
    end
  },
  {
    "aserowy/tmux.nvim",
    config = function()
      require("tmux").setup()
    end,
  },
  { "p00f/nvim-ts-rainbow" },
  { "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup()
    end
  }
}

-- Plugin Settings
lvim.keys.normal_mode["<C-k>"] = "<cmd>ZenMode<cr>"

-- Autocmd for LaTeX: Compile & Preview with Skim
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = {
    "*.tex"
  },
  callback = function()
    vim.cmd [[
      nnoremap <buffer> tc :!xelatex %<CR> 
      nnoremap <buffer> tp :!open -a Skim %:r.pdf<CR><CR>
    ]]
  end,
})

-- Enable spell checking for certain file types
vim.api.nvim_create_autocmd(
  { "BufRead", "BufNewFile" },
  { pattern = { "*.txt", "*.md", "*.tex" }, command = "setlocal spell" }
)
