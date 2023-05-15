--local on_attach = require("plugins.configs.lspconfig").on_attach
--local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
require'lspconfig'.clangd.setup{ on_attach = require("lsp-format").on_attach }
--require'lspconfig'.clangformat.setup{}

