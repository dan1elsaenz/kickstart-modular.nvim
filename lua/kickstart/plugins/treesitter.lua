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
      local ts = require 'nvim-treesitter'

      ts.install {
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
      local available_parsers = ts.get_available()
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local buf, filetype = args.buf, args.match

          -- Let vimtex handle syntax highlighting for LaTeX files
          local latex_filetypes = { tex = true, plaintex = true, context = true }
          if latex_filetypes[filetype] then return end

          local language = vim.treesitter.language.get_lang(filetype)
          if not language then return end

          local installed_parsers = ts.get_installed 'parsers'

          if vim.tbl_contains(installed_parsers, language) then
            -- enable the parser if it is installed
            treesitter_try_attach(buf, language)
          elseif vim.tbl_contains(available_parsers, language) then
            -- install asynchronously; nvim-treesitter will reattach to matching buffers when done
            ts.install(language)
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
