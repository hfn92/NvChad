local ls = require "luasnip"
local c = ls.choice_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep
local treesitter_postfix = require("luasnip.extras.treesitter_postfix").treesitter_postfix
local postfix = require("luasnip.extras.postfix").postfix
local postfix_builtin = require("luasnip.extras.treesitter_postfix").builtin
local extras = require "luasnip.extras"
local l = extras.lambda

local reg_match_var = "[%w%.%_%-*:<>{}()]+$"

local pfhelper = require "postfix_helper"
local pfd = pfhelper.create_ts_postfix_d

return {
  -- Shorthand
  -- ls.parser.parse_snippet({trig = "lsp"}, "$1 xFFF is ${2|hard,easy,challenging|}"),
  pfd("+=", function(m)
    return sn(nil, fmt(string.format([[%s = %s + {}]], m, m), { i(1) }))
  end),
  pfd("-=", function(m)
    return sn(nil, fmt(string.format([[%s = %s - {}]], m, m), { i(1) }))
  end),
  pfd("/=", function(m)
    return sn(nil, fmt(string.format([[%s = %s / {}]], m, m), { i(1) }))
  end),
  pfd("*=", function(m)
    return sn(nil, fmt(string.format([[%s = %s * {}]], m, m), { i(1) }))
  end),
  pfhelper.gen_postfix_trigger_d("/p", "{}(%s)"),

  -- postfix({ trig = "-=", match_pattern = reg_match_var }, {
  --   d(1, function(_, parent)
  --     return sn(nil, fmt(string.format([[%s = %s - {}]], parent.env.POSTFIX_MATCH, parent.env.POSTFIX_MATCH), { i(1) }))
  --   end),
  -- }),
  -- postfix({ trig = "/=", match_pattern = reg_match_var }, {
  --   d(1, function(_, parent)
  --     return sn(nil, fmt(string.format([[%s = %s / {}]], parent.env.POSTFIX_MATCH, parent.env.POSTFIX_MATCH), { i(1) }))
  --   end),
  -- }),
  -- postfix({ trig = "*=", match_pattern = reg_match_var }, {
  --   d(1, function(_, parent)
  --     return sn(nil, fmt(string.format([[%s = %s * {}]], parent.env.POSTFIX_MATCH, parent.env.POSTFIX_MATCH), { i(1) }))
  --   end),
  -- }),
}
