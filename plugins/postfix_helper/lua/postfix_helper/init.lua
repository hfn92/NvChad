local treesitter_postfix = require("luasnip.extras.treesitter_postfix").treesitter_postfix
local postfix_builtin = require("luasnip.extras.treesitter_postfix").builtin
local ls = require "luasnip"
local f = ls.function_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

local M = {}

function M._create_ts_postfix(trigger, fn)
  return treesitter_postfix({
    reparseBuffer = "live",
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
      "dot_index_expression",
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

function M.create_ts_postfix(trigger, fn)
  return M._create_ts_postfix(trigger, {
    f(function(_, parent)
      if type(parent.snippet.env.LS_TSMATCH) == "table" then
        local node_content = table.concat(parent.snippet.env.LS_TSMATCH, "\n")
        return fn(node_content)
      end
    end),
  })
end

function M.create_ts_postfix_d(trigger, fn)
  return M._create_ts_postfix(trigger, {
    d(1, function(_, parent)
      if type(parent.snippet.env.LS_TSMATCH) == "table" then
        local node_content = table.concat(parent.snippet.env.LS_TSMATCH, "\n")
        return fn(node_content)
      end
      return fn ""
    end),
  })
end

function M.gen_postfix_trigger_d(k, v, idx)
  if not idx then
    idx = { i(1) }
  end
  return M.create_ts_postfix_d(k, function(m)
    return sn(nil, fmt(string.format(v, m), idx))
  end)
end

function M.gen_postfix_trigger(k, v)
  return M.create_ts_postfix(k, function(m)
    return string.format(v, m)
  end)
end

return M
