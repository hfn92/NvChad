local null_ls = require "null-ls"

local formatting = null_ls.builtins.formatting
local lint = null_ls.builtins.diagnostics

local sources = {
  null_ls.builtins.code_actions.refactoring.with {
    filetypes = { "cpp", "c" },
  },
  formatting.cmake_format,
  -- formatting.prettier,
  formatting.stylua,
  formatting.cmake_format,
  -- formatting.cmake_lint,
  --formatting.clang_format,
  lint.shellcheck,
  lint.markdownlint,
  formatting.markdownlint,
  -- null_ls.builtins.diagnostics.glslc.with {
  --   extra_args = { "--target-env=opengl", "-std=330core", "-fauto-map-locations" }, -- use opengl instead of vulkan1.0
  -- },
  --lint.cppcheck,
}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup {
  --debug = true,
  sources = sources,
  on_attach = function(client, bufnr)
    if client.supports_method "textDocument/formatting" then
      vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
          -- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
          vim.lsp.buf.format { async = false }
        end,
      })
    end
  end,
}

require("null-ls").register {
  name = "GTestActions",
  method = { require("null-ls").methods.CODE_ACTION },
  filetypes = { "cpp" },
  generator = {
    fn = function()
      local actions = require("cmake-gtest").get_code_actions()
      if actions == nil then
        return
      end
      local result = {}
      for idx, v in ipairs(actions.display) do
        table.insert(result, { title = v, action = actions.fn[idx] })
      end
      return result
    end,
  },
}
