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

-- Return snippet tables
return {
  -- GENERIC ENVIRONMENT
  s(
    { trig = 'begin', snippetType = 'autosnippet' },
    fmta(
      [[
        \begin{<>}
            <>
        \end{<>}
      ]],
      {
        i(1),
        d(2, get_visual),
        rep(1),
      }
    ),
    { condition = line_begin }
  ),

  -- EQUATION
  s(
    { trig = 'nn', snippetType = 'autosnippet' },
    fmta(
      [[
        \begin{equation}
            <>
        \end{equation}
      ]],
      {
        i(1),
      }
    ),
    { condition = line_begin }
  ),

  -- SPLIT EQUATION
  s(
    { trig = 'ss', snippetType = 'autosnippet' },
    fmta(
      [[
        \begin{equation}
            \begin{split}
                <>
            \end{split}
        \end{equation}
      ]],
      {
        d(1, get_visual),
      }
    ),
    { condition = line_begin }
  ),

  -- ALIGN
  s(
    { trig = 'all', snippetType = 'autosnippet' },
    fmta(
      [[
        \begin{align*}
            <>
        \end{align*}
      ]],
      {
        i(1),
      }
    ),
    { condition = line_begin }
  ),

  -- ITEMIZE
  s(
    { trig = 'itt', snippetType = 'autosnippet' },
    fmta(
      [[
        \begin{itemize}

            \item <>

        \end{itemize}
      ]],
      {
        i(0),
      }
    ),
    { condition = line_begin }
  ),

  -- ENUMERATE
  s(
    { trig = 'enn', snippetType = 'autosnippet' },
    fmta(
      [[
        \begin{enumerate}

            \item <>

        \end{enumerate}
      ]],
      {
        i(0),
      }
    )
  ),

  -- INLINE MATH
  s(
    { trig = '([^%l])mm', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>$<>$', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),

  -- FIGURE
  s(
    { trig = 'fig' },
    fmta(
      [[
        \begin{figure}[H]
          \centering
          \includegraphics[width=<>\linewidth]{images/<>}
          \caption{<>}
          \label{fig:<>}
        \end{figure}
        ]],
      {
        i(1, 'width'),
        i(2, 'path'),
        i(3, 'caption'),
        i(4, 'label'),
      }
    ),
    { condition = line_begin }
  ),

  -- TABLE
  s(
    { trig = 'table' },
    fmta(
      [[
        \begin{table}[H]
          \centering
          \label{tab:<>}
          \caption{<>}
          \begin{tabular}{cc}
          \hline
          <> & <> 
          \hline
          \end{tabular}
        \end{table}
      ]],
      {
        i(1, 'label'),
        i(2, 'caption'),
        i(3, '1'),
        i(4, '2'),
      }
    ),
    { condition = line_begin }
  ),

  -- CIRCUITIKZ
  s(
    { trig = 'circuitikz', wordTrig = false, snippetType = 'autosnippet' },
    fmta(
      [[
      \begin{figure}[H]
          \centering
          \begin{circuitikz}
              \ctikzset{resistors/scale=0.7}
              \ctikzset{capacitors/scale=0.7}
              \ctikzset{diodes/scale=0.7}
          
              \draw (0,0)

              ;
              
          \end{circuitikz}
          \caption{<>}
          \label{fig:<>}
      \end{figure}
      ]],
      {
        i(1, 'caption'),
        i(2, 'label'),
      }
    ),
    { condition = line_begin }
  ),

  -- INKSCAPE
  s(
    { trig = 'inkscape' },
    fmta(
      [[
      \begin{figure}[H]
          \centering
          \def\svgwidth{1\textwidth}
          \import{inkscape/<>}{<>.pdf_tex}
          \caption{<>}
          \label{fig:<>}
      \end{figure}
      ]],
      {
        i(1, 'path'),
        d(2, get_visual),
        i(3, 'caption'),
        i(4, 'label'),
      }
    ),
    { condition = line_begin }
  ),
}
