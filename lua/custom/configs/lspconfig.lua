--local on_attach = require("plugins.configs.lspconfig").on_attach
--local capabilities = require("plugins.configs.lspconfig").capabilities

local setup = {
  on_attach = function(client, bufnr)
    require "lsp_signature".on_attach(client, bufnr)  -- Note: add in lsp client on-attach
    require("lsp-format").on_attach (client, bufnr)
  end
}

local lspconfig = require "lspconfig"
    local ccapabilities = vim.lsp.protocol.make_client_capabilities()
    ccapabilities.offsetEncoding = { "utf-16" }
--require'lspconfig'.clangd.setup{ on_attach = require("lsp-format").on_attach }
require'lspconfig'.clangd.setup{
  on_attach = function(client, bufnr)
    require "lsp_signature".on_attach(client, bufnr)  -- Note: add in lsp client on-attach
    require("lsp-format").on_attach (client, bufnr)
    client.server_capabilities.semanticTokensProvider = nil
  end,
  capabilities = ccapabilities
}
require'lspconfig'.cmake.setup{}
require'lspconfig'.glslls.setup{ { filetypes = "fsh" } }
