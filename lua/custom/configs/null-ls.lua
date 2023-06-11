local null_ls = require "null-ls"

local formatting = null_ls.builtins.formatting
local lint = null_ls.builtins.diagnostics


local sources = {
  null_ls.builtins.code_actions.refactoring.with({
    filetypes = { "cpp", "c" }
  }),
  formatting.prettier,
  formatting.stylua,
  --formatting.clang_format,
  lint.shellcheck,
  --lint.cppcheck,
}

null_ls.setup {
   --debug = true,
   sources = sources,
}

require'null-ls'.register({
  name = 'GTestActions',
  method = {require'null-ls'.methods.CODE_ACTION},
  filetypes = { 'cpp' },
  generator = {
    fn = function()
      local actions = require("cmake-gtest").get_code_actions()
      if actions == nil then return end
      local result = {}
      for idx, v in ipairs(actions.display) do
        table.insert(result, { title = v, action = actions.fn[idx] })
      end
      return result
    end
  }
})
