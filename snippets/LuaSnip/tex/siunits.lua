-- SI UNITS config
local ls = require 'luasnip'
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta
local rep = require('luasnip.extras').rep

function get_visual(args, parent)
  if #parent.snippet.env.LS_SELECT_RAW > 0 then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else
    return sn(nil, i(1, ''))
  end
end

-- Math context detection
local tex = {}
tex.in_mathzone = function()
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end
tex.in_text = function()
  return not tex.in_mathzone()
end

local line_begin = require('luasnip.extras.expand_conditions').line_begin

return {
  -- SI UNITS
  s(
    { trig = 'unn', snippetType = 'autosnippet' },
    fmta([[\SI{<>}{<>}]], {
      d(1, get_visual),
      i(2, 'unit'),
    })
  ),

  -- Volts
  s({ trig = 'volt', snippetType = 'autosnippet' }, fmta([[\volt]], {})),

  -- Ampere
  s({ trig = 'ampere', snippetType = 'autosnippet' }, fmta([[\ampere]], {})),

  -- second
  s({ trig = 'second', snippetType = 'autosnippet' }, fmta([[\second]], {})),

  -- Ohm
  s({ trig = 'ohm', snippetType = 'autosnippet' }, fmta([[\ohm]], {})),

  -- Farad
  s({ trig = 'farad', snippetType = 'autosnippet' }, fmta([[\farad]], {})),

  -- Hertz
  s({ trig = 'hertz', snippetType = 'autosnippet' }, fmta([[\hertz]], {})),
}
