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

local function gen_postfix(trigger, fn)
  return postfix(
    { trig = trigger, match_pattern = "[%w%.%_%-:<>]+$" },
    { f(function(_, parent)
      return fn(parent.snippet.env.POSTFIX_MATCH)
    end, {}) }
  )
end

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

local reg_match_var = "[%w%.%_%-*:<>{}()]+$"

local function _create_ts_postfix(trigger, fn)
  return treesitter_postfix({
    trig = trigger,
    matchTSNode = postfix_builtin.tsnode_matcher.find_topmost_types {
      "call_expression",
      "identifier",
      "template_function",
      "subscript_expression",
      "field_expression",
      "user_defined_literal",
      -- types?
      "primitive_type",
      "type_identifier",
      "qualified_identifier",
      "expression_statement",
    },
    -- matchTSNode = {
    --   query = [[
    --       [
    --         (call_expression)
    --         (identifier)
    --         (template_function)
    --         (subscript_expression)
    --         (field_expression)
    --         (user_defined_literal)
    --       ] @prefix
    --   ]],
    -- },
  }, fn)
end

local function create_ts_postfix(trigger, fn)
  return _create_ts_postfix(trigger, {
    f(function(_, parent)
      if type(parent.snippet.env.LS_TSMATCH) == "table" then
        local node_content = table.concat(parent.snippet.env.LS_TSMATCH, "\n")
        return fn(node_content)
      end
    end),
  })
end

local function create_ts_postfix_d(trigger, fn)
  return _create_ts_postfix(trigger, {
    d(1, function(_, parent)
      if type(parent.snippet.env.LS_TSMATCH) == "table" then
        local node_content = table.concat(parent.snippet.env.LS_TSMATCH, "\n")
        return fn(node_content)
      end
      return fn ""
    end),
  })
end

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
  -- s("!en", { t "std::endl" }),
  -- s("!sv", { t "std::string_view" }),
  -- s("!st", { t "std::string" }),
  -- s("!up", fmt("std::unique_ptr<{}>", { i(1) }, { delimiters = "{}" })),
  -- s("!sp", fmt("std::shared_ptr<{}>", { i(1) }, { delimiters = "{}" })),
  -- s("!wp", fmt("std::weak_ptr<{}>", { i(1) }, { delimiters = "{}" })),
  -- s("!um", fmt("std::unordered_map<{}, {}>", { i(1), i(2) })),
  -- s("!pr", fmt("std::pair<{}, {}>", { i(1), i(2) })),
  -- s("!om", fmt("std::map<{}, {}>", { i(1), i(2) })),
  -- s("!mu", fmt("std::make_unique<{}>({})", { i(1), i(2) })),
  -- s("!ms", fmt("std::make_shared<{}>({})", { i(1), i(2) })),
  -- s("!op", fmt("std::optional<{}>", { i(1) })),
  -- s("!ve", fmt("std::vector<{}>", { i(1) })),
  -- s("!sm", fmt("SmallVector<{}, {}>", { i(1), i(2) })),
  -- s("!mv", fmt("std::move({})", { i(1) }, { delimiters = "{}" })),
  -- s("!ar", fmt("std::array<{}, {}>", { i(1), i(2) }, { delimiters = "{}" })),
  -- s("!sc", fmt("static_cast<{}>({})", { i(1), i(2) })),
  -- s("!rc", fmt("reinterpret_cast<{}>({})", { i(1), i(2) })),
  -- s("!dc", fmt("dynamic_cast<{}>({})", { i(1), i(2) })),
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

  create_ts_postfix("/ve", function(m)
    return "std::vector<" .. m .. ">"
  end),

  create_ts_postfix("/cr", function(m)
    return "const " .. m .. "& "
  end),

  create_ts_postfix("/re", function(m)
    return "return " .. m .. ";"
  end),

  create_ts_postfix("/st", function(m)
    return "std::string(" .. m .. ")"
  end),

  create_ts_postfix("/mv", function(m)
    return "std::move(" .. m .. ")"
  end),

  create_ts_postfix_d("/tpl", function(m)
    return sn(nil, fmt(string.format([[{}<%s>]], m), { i(1) }))
  end),

  create_ts_postfix_d("/var", function(m)
    return sn(nil, fmt(string.format([[auto {} = %s;]], m), { i(1) }))
  end),

  create_ts_postfix_d("/sc", function(m)
    return sn(nil, fmt(string.format([[static_cast<{}>(%s)]], m), { i(1) }))
  end),

  create_ts_postfix_d("/dc", function(m)
    return sn(nil, fmt(string.format([[dynamic_cast<{}>(%s)]], m), { i(1) }))
  end),

  create_ts_postfix_d("/rc", function(m)
    return sn(nil, fmt(string.format([[reinterpret_cast<{}>(%s)]], m), { i(1) }))
  end),

  create_ts_postfix_d("/not", function(m)
    return sn(
      nil,
      fmt(
        string.format(
          [[
if (!%s)
{
  <>
}]],
          m
        ),
        { i(1) },
        { delimiters = "<>" }
      )
    )
  end),

  create_ts_postfix_d("/ne", function(m)
    return sn(
      nil,
      fmt(
        string.format(
          [[
if (%s != <>)
{
  <>
}]],
          m
        ),
        { i(1), i(2) },
        { delimiters = "<>" }
      )
    )
  end),

  create_ts_postfix_d("/eq", function(m)
    return sn(
      nil,
      fmt(
        string.format(
          [[
if (%s == <>)
{
  <>
}]],
          m
        ),
        { i(1), i(2) },
        { delimiters = "<>" }
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
  <>
}]],
          m
        ),
        { i(1) },
        { delimiters = "<>" }
      )
    )
  end),

  create_ts_postfix_d("/initif", function(m)
    return sn(
      nil,
      fmt(
        string.format(
          [[
if (auto <> = %s)
{
  <>
}]],
          m
        ),
        { i(1), i(2) },
        { delimiters = "<>" }
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
  <>
}]],
          m
        ),
        { i(1) },
        { delimiters = "<>" }
      )
    )
  end),

  create_ts_postfix_d("/for", function(m)
    return sn(
      nil,
      fmt(
        string.format(
          [[
for ({} {} : %s)
{{
  {}
}}]],
          m
        ),
        { i(1, "auto&"), i(2, "i"), i(3) }
      )
    )
  end),
}
