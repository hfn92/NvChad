local plugins = {
  {
    "lukas-reineke/lsp-format.nvim",
     config = function()
       require("lsp-format").setup{}
     end,
  },
  {
     "neovim/nvim-lspconfig",
     config = function()
       require "plugins.configs.lspconfig"
       require "custom.configs.lspconfig"
     end,
  }
}
return plugins
