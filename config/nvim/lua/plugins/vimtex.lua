return {
  "lervag/vimtex",
  lazy = false,
  ft = "tex",
  init = function()
    vim.g.vimtex_view_method = "skim"
    vim.g.vimtex_compiler_method = "latexmk"
    vim.g.vimtex_compiler_latexmk = {
      aux_dir = ".aux",
      out_dir = ".out",
    }
  end,
}
