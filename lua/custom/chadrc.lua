---@type ChadrcConfig 
 local M = {}
 M.ui = {theme = 'chocolate'}
 M.plugins = 'custom/plugins'


M.mappings = {
  general = {
    i = {
      ["<A-Left>"] = { "<C-o>", "Navigate Backwards" },
      ["<A-Right>"] = { "<C-i>", "Navigate Forwards" },
    },

    n = {
      ["<A-Left>"] = { "<C-o>", "Navigate Backwards" },
      ["<A-Right>"] = { "<C-i>", "Navigate Forwards" },
    }
  },
  fab = {
    -- plugin = true,

    i = {
      --["<F2>"] = { "<cmd> lua vim.lsp.buf.declaration() <CR><cmd> lua vim.lsp.buf.definition() <CR>", "Switch Source/Header" },
      ["<A-cr>"] = { "<cmd> lua vim.lsp.buf.code_action() <CR>", "Code Action" },
    },

    n = {
      ["K"] = { "<cmd> lua vim.lsp.buf.hover() <CR>", "Code Action" },
      ["<A-cr>"] = { "<cmd> lua vim.lsp.buf.code_action() <CR>", "Code Action" },
      ["<F2>"] = { "<cmd> lua vim.lsp.buf.declaration() <CR><cmd> lua vim.lsp.buf.definition() <CR>", "Switch Source/Header" },
    }
  },
  telescope = {
    plugin = true,

    n = {
      -- ["<F2>"] = { "<cmd> lua vim.lsp.buf.declaration() <CR><cmd> lua vim.lsp.buf.definition() <CR>", "Switch Source/Header" },
      ["<leader>fs"] = { "<cmd> Telescope lsp_document_symbols <CR>", "[F]ind [S]ymbols" },
      ["<leader>fg"] = { "<cmd> Telescope git_files <CR>", "[F]ind [S]ymbols" },
    }
  }
}

 return M
