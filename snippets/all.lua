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
local l = require("luasnip.extras").lambda
local treesitter_postfix = require("luasnip.extras.treesitter_postfix").treesitter_postfix
local postfix = require("luasnip.extras.postfix").postfix
-- print("xxxxxxxxxxxxxx")
--
vim.keymap.set({ "i", "s" }, "<A-j>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end)
vim.keymap.set({ "i", "s" }, "<A-h>", function()
  if ls.choice_active() then
    ls.change_choice(-1)
  end
end)

vim.keymap.set({ "i", "s" }, "<A-l>", function()
  if ls.jumpable(1) then
    ls.jump(1)
  end
end)

vim.keymap.set({ "i", "s" }, "<A-k>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end)

local e = {
  tter = 1,
  -- %w+tmap
  -- trafo%d+
}

return {
  -- Shorthand
  -- ls.parser.parse_snippet({trig = "lsp"}, "$1 xFFF is ${2|hard,easy,challenging|}"),
  s("!cc", {
    t "//----------------------------------------------------------------------------------------------------------------------",
  }),

  -- treesitter_postfix({
  --   trig = ".mv",
  --   matchTSNode = {
  --     query = [[
  --           [
  --             (call_expression)
  --             (identifier)
  --             (template_function)
  --             (subscript_expression)
  --             (field_expression)
  --             (user_defined_literal)
  --           ] @prefix
  --       ]],
  --     query_lang = "cpp",
  --   },
  -- }, {
  --   f(function(_, parent)
  --     local node_content = table.concat(parent.snippet.env.LS_TSMATCH, "\n")
  --     local replaced_content = ("std::move(%s)"):format(node_content)
  --     return vim.split(ret_str, "\n", { trimempty = false })
  --   end),
  -- }),
}
