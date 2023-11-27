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

local function GetClassName()
  local ts_utils = require "nvim-treesitter.ts_utils"
  local current_node = ts_utils.get_node_at_cursor()
  if not current_node then
    return ""
  end

  local expr = current_node

  while expr do
    if expr:type() == "class_specifier" then
      break
    end
    expr = expr:parent()
  end

  if not expr then
    return ""
  end

  return vim.treesitter.get_node_text(expr:child(1), 0)
end

return {
  -- Shorthand
  -- ls.parser.parse_snippet({trig = "lsp"}, "$1 xFFF is ${2|hard,easy,challenging|}"),
  s("[]", fmt("[](auto& i){<>}", { i(1) }, { delimiters = "<>" })),
  s("!en", { t "std::endl" }),
  s("sv", { t "std::string_view" }),
  s("st", { t "std::string" }),
  s("!sv", { t "std::string_view" }),
  s("!st", { t "std::string" }),
  s("!up", fmt("std::unique_ptr<{}>", { i(1) }, { delimiters = "{}" })),
  s("!sp", fmt("std::shared_ptr<{}>", { i(1) }, { delimiters = "{}" })),
  s("!wp", fmt("std::weak_ptr<{}>", { i(1) }, { delimiters = "{}" })),
  s("!um", fmt("std::unordered_map<{}, {}>", { i(1), i(2) })),
  s("!pr", fmt("std::pair<{}, {}>", { i(1), i(2) })),
  s("!om", fmt("std::map<{}, {}>", { i(1), i(2) })),
  s("!mu", fmt("std::make_unique<{}>({})", { i(1), i(2) })),
  s("!ms", fmt("std::make_shared<{}>({})", { i(1), i(2) })),
  s("!op", fmt("std::optional<{}>", { i(1) })),
  s("!ve", fmt("std::vector<{}>", { i(1) })),
  s("!sm", fmt("SmallVector<{}, {}>", { i(1), i(2) })),
  s("!mv", fmt("std::move({})", { i(1) }, { delimiters = "{}" })),
  s("!ar", fmt("std::array<{}, {}>", { i(1), i(2) }, { delimiters = "{}" })),
  s("move", fmt("std::move({})", { i(1) }, { delimiters = "{}" })),
  s("mv", fmt("std::move({})", { i(1) }, { delimiters = "{}" })),
  s("array", fmt("std::array<{}, {}>", { i(1), i(2) }, { delimiters = "{}" })),
  s(
    "fora",
    fmt(
      [[
for ({} {} : {})
{{
  {}
}}]],
      { i(1, "auto&"), i(2, "i"), i(3), i(4) }
    )
  ),
  s(
    "fn",
    fmt(
      [[
{} {}({})
{{
  {}
}}]],
      { i(1, "void"), i(2), i(3), i(4) }
    )
  ),

  s(
    "me",
    fmt(
      [[
{r} {n}({p}){m};
{r} {cls}::{n}({p}){m}
{{
  {}
}}]],
      {
        r = i(1, "void"),
        n = i(2),
        p = i(3),
        m = c(4, { t "", t " const noexcept", t " const", t " noexcept" }),
        cls = f(function()
          return GetClassName()
        end),
        i(5),
      },
      { repeat_duplicates = true }
    )
  ),
}
