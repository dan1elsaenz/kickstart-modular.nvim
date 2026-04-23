---@module 'lazy'
---@type LazySpec
return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    branch = 'main',
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter-intro`
    config = function()
      local ts_info = require 'nvim-treesitter.info'
      local ts_install = require 'nvim-treesitter.install'
      local ts_parsers = require 'nvim-treesitter.parsers'

      -- ensure basic parser are installed
      local parsers = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
      }
      ts_install.ensure_installed(parsers)
      -- associate SystemVerilog filetypes with the Verilog parser
      vim.treesitter.language.register('verilog', { 'systemverilog', 'sv', 'svh' })
      ---@param buf integer
      ---@param language string
      local function treesitter_try_attach(buf, language)
        -- check if parser exists and load it
        local ok = pcall(vim.treesitter.language.add, language)
        if not ok then return end
        -- enables syntax highlighting and other treesitter features
        ok = pcall(vim.treesitter.start, buf, language)
        if not ok then return end
        -- enables treesitter based folds
        -- for more info on folds see `:help folds`
        -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        -- vim.wo.foldmethod = 'expr'
        -- check if treesitter indentation is available for this language, and if so enable it
        -- in case there is no indent query, the indentexpr will fallback to the vim's built in one
        local has_indent_query = vim.treesitter.query.get(language, 'indent') ~= nil
        -- enables treesitter based indentation
        if has_indent_query then vim.bo.indentexpr = 'nvim_treesitter#indent()' end
      end
      local available_parsers = ts_parsers.available_parsers()
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local buf, filetype = args.buf, args.match

          -- Let vimtex handle syntax highlighting for LaTeX files
          local latex_filetypes = { tex = true, plaintex = true, context = true }
          if latex_filetypes[filetype] then return end

          local language = vim.treesitter.language.get_lang(filetype)
          if not language then return end

          local installed_parsers = ts_info.installed_parsers()

          if vim.tbl_contains(installed_parsers, language) then
            -- enable the parser if it is installed
            treesitter_try_attach(buf, language)
          elseif vim.tbl_contains(available_parsers, language) then
            -- install asynchronously; nvim-treesitter will reattach to matching buffers when done
            ts_install.ensure_installed(language)
          else
            -- try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
            treesitter_try_attach(buf, language)
          end
        end,
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
