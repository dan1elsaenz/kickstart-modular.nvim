---@module 'lazy'
---@type LazySpec
return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function() require('conform').format { async = true, lsp_format = 'fallback' } end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    ---@module 'conform'
    ---@type conform.setupOpts
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        return {
          timeout_ms = 500,
          lsp_format = 'fallback',
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        c = { 'clang-format' },
        cpp = { 'clang-format' },
        python = { 'ruff_format' },
        markdown = { 'prettierd' },
        verilog = { 'verible-verilog-format' },
        systemverilog = { 'verible-verilog-format' },
      },
      formatters = {
        verible_verilog_format = {
          command = 'verible-verilog-format',
          args = { '-' },
          stdin = true,
        },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
