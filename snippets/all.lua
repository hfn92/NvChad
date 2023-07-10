
local ls = require("luasnip")
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
-- vim.keymap.set({ "i", "s" }, "<C-Down>", function()
--   if ls.choice_active() then
--     ls.change_choice(1)
--   end
-- end)
-- vim.keymap.set({ "i", "s" }, "<C-Up>", function()
--   if ls.choice_active() then
--  ls.change_choice(-1)
--  end
-- end)
return {
  -- Shorthand
  -- ls.parser.parse_snippet({trig = "lsp"}, "$1 xFFF is ${2|hard,easy,challenging|}"),
  s("end", { t("std::endl"), }),
  s("!up", fmt("std::unique_ptr<{}>", { i(1) }, { delimiters = "{}" })),
  s("!sp", fmt("std::shared_ptr<{}>", { i(1) }, { delimiters = "{}" })),
  s("!wp", fmt("std::weak_ptr<{}>", { i(1) }, { delimiters = "{}" })),
  s("m", fmt("std::move({})", { i(1) }, { delimiters = "{}" })),
  s("ar", fmt("std::array<{}>", { i(1) }, { delimiters = "{}" })),

  -- Here is the equivalent longhand
  s({trig = "hi"},  -- explicitly setting trigger via params table
    { t("Hello, world!"), }
  ),
}

 
