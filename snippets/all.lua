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

return {
  -- Shorthand
  -- ls.parser.parse_snippet({trig = "lsp"}, "$1 xFFF is ${2|hard,easy,challenging|}"),
  s("!cc", {
    t "//----------------------------------------------------------------------------------------------------------------------",
  }),
}
