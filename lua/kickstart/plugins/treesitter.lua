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
      local ts_install = require 'nvim-treesitter.install'
      local ok_parsers, ts_parsers = pcall(require, 'nvim-treesitter.parsers')

      ts_install.install {
        'bash',
        'c',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
      }
      -- associate SystemVerilog filetypes with the Verilog parser
      vim.treesitter.language.register('verilog', { 'systemverilog', 'sv', 'svh' })

      local available_parsers = ok_parsers and vim.tbl_keys(ts_parsers) or {}

      ---@param buf integer
      ---@param language string
      local function treesitter_try_attach(buf, language)
        if not vim.api.nvim_buf_is_valid(buf) then return end
        if vim.bo[buf].buftype ~= '' then return end
        local ok = pcall(vim.treesitter.language.add, language)
        if not ok then return end
        ok = pcall(vim.treesitter.start, buf, language)
        if not ok then return end
        -- check if treesitter indentation is available for this language, and if so enable it
        -- in case there is no indent query, the indentexpr will fallback to the vim's built in one
        local ok2, query = pcall(vim.treesitter.query.get, language, 'indent')
        if ok2 and query ~= nil then vim.bo[buf].indentexpr = 'nvim_treesitter#indent()' end
      end

      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local buf, filetype = args.buf, args.match

          -- Let vimtex handle syntax highlighting for LaTeX files
          local latex_filetypes = { tex = true, plaintex = true, context = true }
          if latex_filetypes[filetype] then return end

          local language = vim.treesitter.language.get_lang(filetype)
          if not language then return end

          -- pcall to check if the parser binary is installed
          local parser_ok = pcall(vim.treesitter.language.add, language)
          if parser_ok then
            treesitter_try_attach(buf, language)
          elseif vim.tbl_contains(available_parsers, language) then
            -- install asynchronously; nvim-treesitter will reattach to matching buffers when done
            ts_install.install(language)
          end
        end,
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
