-- ~/.config/nvim/lua/custom/snippets/markdown.lua
local ls = require 'luasnip'
local s = ls.snippet
local sn = ls.snippet_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta

function get_visual(args, parent)
  if #parent.snippet.env.LS_SELECT_RAW > 0 then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else
    return sn(nil, i(1, ''))
  end
end

return {
  -- IMAGE
  s(
    {
      trig = 'img',
      wordTrig = true,
      dscr = 'Add centered image using HTML',
    },
    fmt('<p>\n\t<img src="{}" width="{}px" alt="{}">\n</p>', {
      i(1, 'source'),
      i(2, 'width'),
      i(3, 'text'),
    })
  ),

  -- BOLDFACE
  s(
    {
      trig = '([^%a])tbb',
      regTrig = true,
      wordTrig = false,
      snippetType = 'autosnippet',
    },
    fmta([[<>**<>**]], {
      f(function(_, snip) return snip.captures[1] end),
      d(1, get_visual),
    })
  ),

  -- ITALIC
  s(
    {
      trig = '([^%a])tii',
      regTrig = true,
      wordTrig = false,
      snippetType = 'autosnippet',
    },
    fmta([[<>_<>_]], {
      f(function(_, snip) return snip.captures[1] end),
      d(1, get_visual),
    })
  ),

  -- CODE
  s(
    {
      trig = 'code',
      wordTrig = false,
      snippetType = 'autosnippet',
    },
    fmta(
      [[
      ```<>
      <>
      ```
      ]],
      {
        i(1, 'lang'),
        d(2, get_visual),
      }
    )
  ),

  -- INLINE CODE
  s(
    {
      trig = '([^%a])cdd',
      regTrig = true,
      wordTrig = false,
      snippetType = 'autosnippet',
    },
    fmta([[<>`<>`]], {
      f(function(_, snip) return snip.captures[1] end),
      d(1, get_visual),
    })
  ),
}
