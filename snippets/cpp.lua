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
local extras = require "luasnip.extras"
local l = extras.lambda

-- local folderOfThisFile = (...):match "(.-)[^%.]+$"
local pfhelper = require "postfix_helper"

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

local pf = pfhelper.gen_postfix_trigger
local pfd = pfhelper.gen_postfix_trigger_d
local create_ts_postfix_d = pfhelper.create_ts_postfix_d
local create_ts_postfix = pfhelper.create_ts_postfix

return {
  -- Shorthand
  -- ls.parser.parse_snippet({trig = "lsp"}, "$1 xFFF is ${2|hard,easy,challenging|}"),
  s("constexpr", { t "constexpr" }),
  s("[]", fmt("[](auto& i){<>}", { i(1) }, { delimiters = "<>" })),
  s(",en", { t "std::endl" }),
  s(",sv", { t "std::string_view" }),
  s(",st", { t "std::string" }),
  s(",up", fmt("std::unique_ptr<{}>", { i(1) }, { delimiters = "{}" })),
  s(",sp", fmt("std::shared_ptr<{}>", { i(1) }, { delimiters = "{}" })),
  s(",wp", fmt("std::weak_ptr<{}>", { i(1) }, { delimiters = "{}" })),
  s(",um", fmt("std::unordered_map<{}, {}>", { i(1), i(2) })),
  s(",pr", fmt("std::pair<{}, {}>", { i(1), i(2) })),
  s(",om", fmt("std::map<{}, {}>", { i(1), i(2) })),
  s(",mu", fmt("std::make_unique<{}>({})", { i(1), i(2) })),
  s(",ms", fmt("std::make_shared<{}>({})", { i(1), i(2) })),
  s(",op", fmt("std::optional<{}>", { i(1) })),
  s(",ve", fmt("std::vector<{}>", { i(1) })),
  s(",sm", fmt("SmallVector<{}, {}>", { i(1), i(2) })),
  s(",mv", fmt("std::move({})", { i(1) }, { delimiters = "{}" })),
  s(",ar", fmt("std::array<{}, {}>", { i(1), i(2) }, { delimiters = "{}" })),
  s(",sc", fmt("static_cast<{}>({})", { i(1), i(2) })),
  s(",rc", fmt("reinterpret_cast<{}>({})", { i(1), i(2) })),
  s(",dc", fmt("dynamic_cast<{}>({})", { i(1), i(2) })),
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

  pf("/cr", "const %s& "),
  pf("/ve", "std::vector<%s>"),
  pf("/re", "return %s;"),
  pf("/st", "std::string(%s)"),
  pf("/mv", "std::move(%s)"),

  pfd("/tpl", "{}<%s>"),
  pfd("/p", "{}(%s)"),
  pfd("/var", "auto {} = %s;"),
  pfd("/sc", [[static_cast<{}>(%s)]]),
  pfd("/dc", [[dynamic_cast<{}>(%s)]]),
  pfd("/rc", [[reinterpret_cast<{}>(%s)]]),

  s(",fmt", fmt([[fmt::format("{}",{});]], { i(1), i(2) })),
  pfd("/fmt", [[fmt::format("{{}}{}", %s);]]),

  s(",gt", fmt("EXPECT_TRUE({});", { i(1) })),
  s(",gf", fmt("EXPECT_FALSE({});", { i(1) })),
  s(",geq", fmt("EXPECT_EQ({}, {});", { i(1), i(2) })),
  s(",gne", fmt("EXPECT_NE({}, {});", { i(1), i(2) })),
  s(",ggt", fmt("EXPECT_GT({}, {});", { i(1), i(2) })),
  s(",glt", fmt("EXPECT_LT({}, {});", { i(1), i(2) })),
  pf("/gt", "EXPECT_TRUE(%s);"),
  pf("/gf", "EXPECT_FALSE(%s);"),
  pfd("/geq", "EXPECT_EQ({}, %s);"),
  pfd("/gne", "EXPECT_NE({}, %s);"),
  pfd("/ggt", "EXPECT_GT({}, %s);"),
  pfd("/glt", "EXPECT_LT({}, %s);"),

  create_ts_postfix_d("/not", function(m)
    return sn(
      nil,
      fmt(
        string.format(
          [[
if (!%s)
{
  @^
}]],
          m
        ),
        { i(1) },
        { delimiters = "@^" }
      )
    )
  end),

  create_ts_postfix_d("/ne", function(m)
    return sn(
      nil,
      fmt(
        string.format(
          [[
if (%s != @^)
{
  @^
}]],
          m
        ),
        { i(1), i(2) },
        { delimiters = "@^" }
      )
    )
  end),

  create_ts_postfix_d("/eq", function(m)
    return sn(
      nil,
      fmt(
        string.format(
          [[
if (%s == @^)
{
  @^
}]],
          m
        ),
        { i(1), i(2) },
        { delimiters = "@^" }
      )
    )
  end),

  create_ts_postfix_d("/if", function(m)
    return sn(
      nil,
      fmt(
        string.format(
          [[
if (%s)
{
  @^
}]],
          m
        ),
        { i(1) },
        { delimiters = "@^" }
      )
    )
  end),

  create_ts_postfix_d("/initif", function(m)
    return sn(
      nil,
      fmt(
        string.format(
          [[
if (auto @^ = %s)
{
  @^
}]],
          m
        ),
        { i(1), i(2) },
        { delimiters = "@^" }
      )
    )
  end),

  create_ts_postfix_d("/if", function(m)
    return sn(
      nil,
      fmt(
        string.format(
          [[
if (%s)
{
  @^
}]],
          m
        ),
        { i(1) },
        { delimiters = "@^" }
      )
    )
  end),

  create_ts_postfix_d("/for", function(m)
    return sn(
      nil,
      fmt(
        string.format(
          [[
for (@^ @^ : %s)
{
  @^
}]],
          m
        ),
        { i(1, "auto&"), i(2, "i"), i(3) },
        { delimiters = "@^" }
      )
    )
  end),
}
