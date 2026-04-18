return {
  { -- LaTeX plugin
    'lervag/vimtex',

    lazy = false, -- Doesn't require lazy-loading
    -- tag = "v2.15", -- Specific release

    init = function()
      -- VimTeX configuration
      vim.g.tex_flavor = 'latex'
      vim.g.vimtex_view_method = 'skim' -- PDF Reader
      vim.g.vimtex_content_pdf_viewer = 'skim' -- External PDF viewer for the VimTeX menu

      vim.g.vimtex_view_skim_sync = 1
      vim.g.vimtex_view_skim_activate = 1

      vim.g.vimtex_indent_enabled = false -- Disable auto-indent from VimTeX

      vim.g.vimtex_compiler_method = 'latexmk'
      vim.g.vimtex_compiler_latexmk = {
        out_dir = 'out',
        aux_dir = 'out',
        callback = 1,
        continuous = 1,
        executable = 'latexmk',
        options = {
          '-shell-escape',
          '-verbose',
          '-file-line-error',
          '-synctex=1',
          '-interaction=nonstopmode',
          '-pdf',
          '-outdir=out',
        },
      }
      vim.g.vimtex_syntax_enabled = true
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
