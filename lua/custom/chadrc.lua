---@type ChadrcConfig 
 local M = {}

vim.cmd "function! FCmakeSelectTarget(a,b,c,d) \n CMakeSelectBuildType \n endfunction"
vim.cmd "function! FCmakeSelectRun(a,b,c,d) \n CMakeSelectLaunchTarget \n endfunction"
vim.cmd "function! FCmakeSelectBuild(a,b,c,d) \n CMakeSelectBuildTarget \n endfunction"

M.ui =
{
  theme = 'fab',
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
          local args = cmake.get_launch_args()
          arg = ""
          if (args ~= nil) then
            for _, v in ipairs(args) do
              arg = arg .. v
            end
          end

          local str = "%#Hl#"
          .. "   [" .. (type and type or "None") .. "]"
          .. "   [" .. (tgt and tgt or "None") .. "]"
          .. "   [" ..  (run and run or "None") .. "]"
          .. "   <" ..  arg .. ">"
          -- .. "   %@FCmakeSelectTarget@% [" .. (type and type or "None") .. "]"
          -- .. "   %@FCmakeSelectBuild@% [" .. (tgt and tgt or "None") .. "]"
          -- .. "   %@FCmakeSelectRun@% [" ..  (run and run or "None") .. "]"
          -- .. "   <" ..  arg .. ">"
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
      --["<CR>"] = { "o<Esc>", "New Line" },
      ["<C-d>"] = { "<C-d>zz", "Scroll down" },
      ["<C-u>"] = { "<C-u>zz", "Scroll up" },
      ["n"] = { "nzzzv", "next (search)" },
      ["N"] = { "Nzzzv", "previous (search)" },
      ["J"] = { "mzJ`z", "Move next line back" },

      ["<A-Left>"] = { "<C-o>", "Navigate Backwards" },
      ["<A-Right>"] = { "<C-i>", "Navigate Forwards" },
      ["<C-S-s>"] = { "<cmd> wa <CR>", "Save all files" },

      ["<leader>y"] = { "\"+y", "Yank to clipboard" },
      ["<leader>d"] = { "\"_d", "Delete to void" },
    },

    v = {
      ["J"] = { ":m '>+1<CR>gv=gv", "Move down" },
      ["K"] = { ":m '<-2<CR>gv=gv", "Move Up" },
      ["<S-Down>"] = { ":m '>+1<CR>gv=gv", "Move down" },
      ["<S-Up>"] = { ":m '<-2<CR>gv=gv", "Move Up" },

      ["<leader>y"] = { "\"+y", "Yank to clipboard" },
      ["<leader>d"] = { "\"_d", "Delete to void" },
    },
    x = {
      ["<leader>p"] = { "\"_dP", "Paste" },
    }
  },
  cmake = {
    i = {
      ["<C-b>"] = { "<cmd> CMakeBuild <CR>", "CMake [b]uild" },
    },
    n = {
      ["<leader>ct"] = { "<cmd> CMakeSelectBuildTarget <CR>", "Select CMake [t]arget" },
      ["<leader>cb"] = { "<cmd> CMakeBuild <CR>", "CMake [b]uild" },
      ["<leader>cs"] = { "<cmd> CMakeStop <CR>", "CMake [b]uild" },
      ["<leader>cd"] = { "<cmd> CMakeDebug <CR>", "CMake debug" },
      ["<leader>ca"] = {
        function()
          local args = vim.fn.input("Command line args:")
          vim.cmd("CMakeLaunchArgs " .. args)
        end
        , "CMake launch args" },
      ["<C-b>"] = { "<cmd> CMakeBuild <CR>", "CMake [b]uild" },
      ["<leader>cr"] = { "<cmd> CMakeRun <CR>", "CMake [r]un" },
      ["<C-r>"] = { "<cmd> CMakeRun <CR>", "CMake [r]un" },
      ["<leader>cl"] = { "<cmd> CMakeSelectLaunchTarget <CR>", "CMake select [l]aunch target" },
    }
  },
  macros = {
    i = {
    }
  },
  fab = {
    -- plugin = true,

    i = {
      --["<F2>"] = { "<cmd> lua vim.lsp.buf.declaration() <CR><cmd> lua vim.lsp.buf.definition() <CR>", "Switch Source/Header" },
      ["<A-cr>"] = { "<cmd> lua vim.lsp.buf.code_action() <CR>", "Code Action" },
      ["<F4>"] = { "<cmd> ClangdSwitchSourceHeader <CR>", "Switch Source/Header" },

      ["<A-j>"] = { "<cmd>cnext<CR>zz", "Quickfix next" },
      ["<A-k>"] = { "<cmd>cprev<CR>zz", "Quickfix previous" },
    },

    n = {
      ["<C-w>b"] = { "<cmd>%bd|e#<CR>", "Close other buffers" },
      ["K"] = { "<cmd> lua vim.lsp.buf.hover() <CR>", "Hover" },
      ["<F4>"] = { "<cmd> ClangdSwitchSourceHeader <CR>", "Switch Source/Header" },
      ["<A-cr>"] = { "<cmd> lua vim.lsp.buf.code_action() <CR>", "Code Action" },
      ["<F2>"] = { "<cmd> lua vim.lsp.buf.declaration() <CR><cmd> lua vim.lsp.buf.definition() <CR>", "Follow Symbol" },

      ["<leader>fr"] = { "<cmd> lua require('telescope.builtin').lsp_references() <CR>", "Find references" },
      ["<leader>ra"] = { function() require("nvchad_ui.renamer").open() end, "LSP rename", },
      ["<leader>dd"] = { function() vim.diagnostic.open_float { border = "rounded" } end, "Floating diagnostic", },
      ["<A-d>"] = { function() vim.diagnostic.open_float { border = "rounded" } end, "Floating diagnostic", },
      ["<leader>s"] = { [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "Replace under cursor" },

      ["<A-j>"] = { "<cmd>cnext<CR>zz", "Quickfix next" },
      ["<A-k>"] = { "<cmd>cprev<CR>zz", "Quickfix previous" },
      ["<leader>k"] = { "<cmd>lnext<CR>zz", "Location next" },
      ["<leader>j"] = { "<cmd>lprev<CR>zz", "Location previous" },
    },

    v = {
      ["<leader>s"] = { [[:s///<Left><Left>]], "Replace within selection" },
    }


  },
  telescope = {
    plugin = true,

    i = {
      -- ["<A-q"] = {  function ()
      --   local actions = require "telescope.actions"
      --   actions.send_to_qflist()
      --   actions.open_qflist()
      -- end , "Find Symbols" },
    },
     n = {
      ["<leader>fs"] = { "<cmd> Telescope lsp_document_symbols <CR>", "Find Symbols" },
      ["<leader>fe"] = { "<cmd> Telescope lsp_dynamic_workspace_symbols <CR>", "Find symbols everywhere" },
      ["<leader>fg"] = { "<cmd> Telescope git_files <CR>", "Search git files" },
      ["<leader>fc"] = { "<cmd> Telescope git_status <CR>", "Search git diff" },
      ["<leader>fd"] = { "<cmd> Telescope diagnostics <CR>", "Diagnostics" },
    }
  },
  undotree = {
     n = {
      ["<leader>u"] = { vim.cmd.UndotreeToggle, "Undotree" },
    }
  },
  dap = {

    n = {
      ["<F5>"] = { function() require('dap').continue() end , "[F5] continue" },
      ["<F9>"] = { function() require('dap').toggle_breakpoint() end , "[F9] toogle breakpoint" },
      ["<F10>"] = { function() require('dap').step_over() end , "[F10] step over" },
      ["<leader><F10>"] = { function() require('dap').run_to_cursor() end , "Run to cursor" },
      ["<F12>"] = { function() require('dap').step_into() end , "[F12] step into" },
      ["<S-F12>"] = { function() require('dap').step_out() end , "Shift + [F12] step out" },
      ["<F11>"] = { function() require('dap').step_into() end , "[F11] step into" },
      ["<S-F11>"] = { function() require('dap').step_out() end , "Shift + [F11] step out" },

      ["<leader>du"] = { function() require('dapui').toggle() end , "Toggle Debug UI" },
      ["<leader>dq"] = { function() require('dap').terminate() end , "Stop debugging" },
      ["<leader>dc"] = { function() require('dap').clear_breakpoints() end , "Clear breakpoints" },
      ["<leader>dl"] = { function() require('dap').list_breakpoints() end , "List breakpoints" },
      ["<leader>dt"] = { function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end , "Trace point" },
      ["<leader>dr"] = { function() require('dap').repl.toggle() end , "Open repl" },
      ["<leader>dh"] = { function() require('dap.ui.widgets').hover() end , "Hover" },
      ["<leader>dp"] = { function() require('dap.ui.widgets').preview() end , "Preview" },
      ["<leader>df"] = {
        function()
          local w = require('dap.ui.widgets');
          w.centered_float(w.frames)
        end , "Stack frames" },
      ["<leader>ds"] = {
        function()
          local w = require('dap.ui.widgets');
          w.centered_float(w.scopes)
        end , "Variables in Scope" },
    }
  }
}

 return M
