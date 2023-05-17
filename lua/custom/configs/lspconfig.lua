--local on_attach = require("plugins.configs.lspconfig").on_attach
--local capabilities = require("plugins.configs.lspconfig").capabilities

local setup = {
  on_attach = function(client, bufnr)
    require "lsp_signature".on_attach(client, bufnr)  -- Note: add in lsp client on-attach
    require("lsp-format").on_attach (client, bufnr)
  end
}

local lspconfig = require "lspconfig"
--require'lspconfig'.clangd.setup{ on_attach = require("lsp-format").on_attach }
require'lspconfig'.clangd.setup{
  on_attach = function(client, bufnr)
    require "lsp_signature".on_attach(client, bufnr)  -- Note: add in lsp client on-attach
    require("lsp-format").on_attach (client, bufnr)
  end
}
require'lspconfig'.cmake.setup{}
require'lspconfig'.glslls.setup{ { filetypes = "fsh" } }
