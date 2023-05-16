---@type ChadrcConfig 
 local M = {}

vim.cmd "function! FCmakeSelectTarget(a,b,c,d) \n CMakeSelectBuildType \n endfunction"
vim.cmd "function! FCmakeSelectRun(a,b,c,d) \n CMakeSelectLaunchTarget \n endfunction"
vim.cmd "function! FCmakeSelectBuild(a,b,c,d) \n CMakeSelectBuildTarget \n endfunction"

M.ui =
{
  theme = 'chocolate',
  statusline = {
    overriden_modules = function()
      local st_modules = require "nvchad_ui.statusline.default"
      local cmake = require "cmake-tools"
      --local icons = require "user.icons"
      -- this is just default table of statusline modules

      return {
        LSP_progress = function()
          local type = cmake.get_build_type()
          local run = cmake.get_launch_target()
          local tgt = cmake.get_build_target()
          local str = "%#Hl#"
          .. "   %@FCmakeSelectTarget@% [" .. (type and type or "None") .. "]"
          .. "   %@FCmakeSelectBuild@% [" .. (tgt and tgt or "None") .. "]"
          .. "   %@FCmakeSelectRun@% [" ..  (run and run or "None") .. "]"
          return st_modules.LSP_progress() .. str --cmake.get_build_type()
          -- or just return "" to hide this module
        end,
      }
    end,
  },
}

M.plugins = 'custom/plugins'

M.mappings = {
  general = {
    i = {
      ["<A-Left>"] = { "<C-o>", "Navigate Backwards" },
      ["<A-Right>"] = { "<C-i>", "Navigate Forwards" },
      ["<C-s>"] = { "<cmd> w <CR>", "Save file" },
      ["<C-S-s>"] = { "<cmd> wa <CR>", "Save all files" },
    },

    n = {
      ["<A-Left>"] = { "<C-o>", "Navigate Backwards" },
      ["<A-Right>"] = { "<C-i>", "Navigate Forwards" },
      ["<C-S-s>"] = { "<cmd> wa <CR>", "Save all files" },
    }
  },
  cmake = {
    i = {
      ["<C-b>"] = { "<cmd> CMakeBuild <CR>", "CMake [b]uild" },
    },
    n = {
      ["<leader>ct"] = { "<cmd> CMakeSelectBuildTarget <CR>", "Select CMake [t]arget" },
      ["<leader>cb"] = { "<cmd> CMakeBuild <CR>", "CMake [b]uild" },
      ["<C-b>"] = { "<cmd> CMakeBuild <CR>", "CMake [b]uild" },
      ["<leader>cr"] = { "<cmd> CMakeRun <CR>", "CMake [r]un" },
      ["<C-r>"] = { "<cmd> CMakeRun <CR>", "CMake [r]un" },
      ["<leader>cl"] = { "<cmd> CMakeSelectLaunchTarget <CR>", "CMake select [l]aunch target" },
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
