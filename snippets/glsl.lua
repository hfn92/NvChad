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

return {
  -- Shorthand
  -- ls.parser.parse_snippet({trig = "lsp"}, "$1 xFFF is ${2|hard,easy,challenging|}"),
  s("v2", { t "vec2" }),
  s("v3", { t "vec3" }),
  s("v4", { t "vec4" }),
  s("f32", { t "float" }),
  s("texture2DAA", fmt("texture2DAA({})", { i(1) }, { delimiters = "{}" })),
  s("texCoord2DAA", fmt("texCoord2DAA({})", { i(1) }, { delimiters = "{}" })),
  s("Smooth", fmt("Smooth({})", { i(1) }, { delimiters = "{}" })),
  s("fromNDC", fmt("fromNDC({})", { i(1) }, { delimiters = "{}" })),
  s("toNDC", fmt("toNDC({})", { i(1) }, { delimiters = "{}" })),
}
