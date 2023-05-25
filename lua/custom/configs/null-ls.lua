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
