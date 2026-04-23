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

local line_begin = function(line_to_cursor, matched_trigger)
  -- +1 because `string.sub("abcd", 1, -2)` -> abc
  return line_to_cursor:sub(1, -(#matched_trigger + 1)):match '^%s*$'
end

-- Return snippet tables
return {
  -- REFERENCE
  s(
    { trig = ' RR', snippetType = 'autosnippet', wordTrig = false },
    fmta(
      [[
      ~\ref{<>}
      ]],
      {
        d(1, get_visual),
      }
    )
  ),

  -- DOCUMENTCLASS
  s(
    { trig = 'documentclass', snippetType = 'autosnippet' },
    fmta(
      [=[
        \documentclass[<>]{<>}
        ]=],
      {
        i(1, 'letterpaper'),
        i(2, 'article'),
      }
    ),
    { condition = line_begin }
  ),

  -- USE A LATEX PACKAGE
  s(
    { trig = 'pack', snippetType = 'autosnippet' },
    fmta(
      [[
        \usepackage{<>}
        ]],
      {
        d(1, get_visual),
      }
    ),
    { condition = line_begin }
  ),

  -- INPUT a LaTeX file
  s(
    { trig = 'inn', snippetType = 'autosnippet' },
    fmta(
      [[
      \input{<><>}
      ]],
      {
        i(1, '~/dotfiles/config/latex/templates/'),
        i(2),
      }
    ),
    { condition = line_begin }
  ),

  -- LABEL
  s(
    { trig = 'lbl', snippetType = 'autosnippet' },
    fmta(
      [[
      \label{<>}
      ]],
      {
        d(1, get_visual),
      }
    )
  ),

  -- NEW COMMAND
  s(
    { trig = 'nc' },
    fmta([[\newcommand{<>}{<>}]], {
      i(1),
      i(2),
    }),
    { condition = line_begin }
  ),

  -- REFERENCE EQUATION
  s(
    { trig = 'req' },
    fmta([[\eqref{eq:<>}]], {
      i(1, 'text'),
    })
  ),

  -- FIGURE REFERENCE
  s(
    { trig = 'ref' },
    fmta([[\ref{fig:<>}]], {
      i(1, 'reference'),
    })
  ),

  -- URL
  s(
    { trig = 'href', wordTrig = false, snippetType = 'autosnippet' },
    fmta('\\href{<>}{<>}', {
      i(1, 'url'),
      i(2, 'text'),
    })
  ),

  -- href command with URL in visual selection
  s(
    { trig = 'URL', snippetType = 'autosnippet' },
    fmta([[\href{<>}{<>}]], {
      d(1, get_visual),
      i(2, 'text'),
    })
  ),

  -- VSPACE
  s(
    { trig = 'vss', snippetType = 'autosnippet' },
    fmta([[\vspace{<>}]], {
      d(1, get_visual),
    })
  ),

  -- SECTION
  s(
    { trig = 'h1', snippetType = 'autosnippet' },
    fmta([[\section{<>}]], {
      d(1, get_visual),
    })
  ),

  -- SUBSECTION
  s(
    { trig = 'h2', snippetType = 'autosnippet' },
    fmta([[\subsection{<>}]], {
      d(1, get_visual),
    })
  ),

  -- SUBSUBSECTION
  s(
    { trig = 'h3', snippetType = 'autosnippet' },
    fmta([[\subsubsection{<>}]], {
      d(1, get_visual),
    })
  ),
}
