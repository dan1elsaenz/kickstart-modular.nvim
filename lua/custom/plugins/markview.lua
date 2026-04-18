return {
  'OXY2DEV/markview.nvim',
  lazy = false,

  opts = {
    preview = { enable = false },
  },

  keys = {
    { '<leader>m', '<cmd>Markview<cr>', desc = 'Markview: toggle preview' },
  },
  -- Completion for `blink.cmp`
  -- dependencies = { "saghen/blink.cmp" },
}
