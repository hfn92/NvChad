--local on_attach = require("plugins.configs.lspconfig").on_attach
--local capabilities = require("plugins.configs.lspconfig").capabilities

local setup = {
  on_attach = function(client, bufnr)
    require("lsp_signature").on_attach(client, bufnr) -- Note: add in lsp client on-attach
    require("lsp-format").on_attach(client, bufnr)
  end,
}

local lspconfig = require "lspconfig"
local ccapabilities = vim.lsp.protocol.make_client_capabilities()
ccapabilities.offsetEncoding = { "utf-16" }
--require'lspconfig'.clangd.setup{ on_attach = require("lsp-format").on_attach }
require("lspconfig").clangd.setup {
  on_attach = function(client, bufnr)
    require("lsp_signature").on_attach(client, bufnr) -- Note: add in lsp client on-attach
    require("lsp-format").on_attach(client, bufnr)
    client.server_capabilities.semanticTokensProvider = nil
  end,
  on_new_config = function(new_config, new_cwd)
    local status, cmake = pcall(require, "cmake-tools")
    if status then
      cmake.clangd_on_new_config(new_config)
    end
  end,
  capabilities = ccapabilities,
  filetypes = { "c", "cpp" },
  cmd = {
    "clangd",
    "--clang-tidy",
    "--header-insertion=never",
  },
}
require("lspconfig").lua_ls.setup {
  on_attach = function(client, bufnr)
    -- require("lsp_signature").on_attach(client, bufnr) -- Note: add in lsp client on-attach
    -- require("lsp-format").on_attach(client, bufnr)
    -- client.server_capabilities.semanticTokensProvider = nil
    client.server_capabilities.documentFormattingProvider = false -- 0.8 and later
  end,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}
require("lspconfig").cmake.setup {}
require("lspconfig").asm_lsp.setup {}
require("lspconfig").pylsp.setup {}
-- require("lspconfig").taplo.setup {}
-- require("lspconfig").glslls.setup {
--   cmd = {
--     "/home/fab/Desktop/glsl-language-server/build/Debug/glslls",
--     "--stdin",
--     "-l",
--     "/tmp/log.txt",
--     "-v",
--     "--target-env",
--     "opengl",
--     -- "--target-spv=spv1.0"
--   },
-- }
