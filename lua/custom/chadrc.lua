---@type ChadrcConfig
local M = {}

vim.cmd "function! FCmakeSelectTarget(a,b,c,d) \n CMakeSelectBuildType \n endfunction"
vim.cmd "function! FCmakeSelectRun(a,b,c,d) \n CMakeSelectLaunchTarget \n endfunction"
vim.cmd "function! FCmakeSelectBuild(a,b,c,d) \n CMakeSelectBuildTarget \n endfunction"

function GitSignCodeAction()
  local ok, gitsigns_actions = pcall(require("gitsigns").get_actions)
  if not ok or not gitsigns_actions then
    return
  end

  local names = {}
  for name in pairs(gitsigns_actions) do
    table.insert(names, name)
  end

  vim.ui.select(names, { prompt = "Select launch target" }, function(_, idx)
    if not idx then
      return
    end
    gitsigns_actions[names[idx]]()
  end)
end

function RunPerf()
  local cmake = require "cmake-tools"
  cmake.run { wrap_call = { "perf", "record", "--call-graph", "dwarf" } }
end

function AnalyzePerf()
  local cmake = require "cmake-tools"
  local target = cmake.get_launch_target()

  cmake.get_cmake_launch_targets(function(targets_res)
    if targets_res == nil then
      vim.cmd "CMakeGenerate"
      if targets_res == nil then
        return
      end
    end
    local targets, targetPaths = targets_res.data.targets, targets_res.data.abs_paths
    for idx, itarget in ipairs(targets) do
      if itarget == target then
        local target_dir = vim.fn.fnamemodify(targetPaths[idx], ":h")
        local perf = require "perfanno"
        perf.load_perf_callgraph { fargs = { target_dir .. "/perf.data" } }
      end
    end
  end)
end

function RunPerfQuick()
  local cmake = require "cmake-tools"
  cmake.quick_run { fargs = {}, wrap_call = { "perf", "record", "--call-graph", "dwarf" } }
end

function RunValgrind()
  local cmake = require "cmake-tools"
  cmake.run { wrap_call = { "valgrind", "--leak-check=full" } }
end

M.ui = {
  theme = "fab",
  -- hl_override = {
  --   CursorLine = { bg = "one_bg2" },
  -- },
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
          if args ~= nil then
            for _, v in ipairs(args) do
              arg = arg .. v
            end
          end

          local str = "%#Hl#"
              .. "   ["
              .. (type and type or "None")
              .. "]"
              .. "   ["
              .. (tgt and tgt or "None")
              .. "]"
              .. "   ["
              .. (run and run or "None")
              .. "]"
              .. "   <"
              .. arg
              .. ">"
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

M.plugins = "custom/plugins"

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

      ["<leader>y"] = { '"+y', "Yank to clipboard" },
      ["<leader>d"] = { '"_d', "Delete to void" },
    },

    v = {
      ["J"] = { ":m '>+1<CR>gv=gv", "Move down" },
      ["K"] = { ":m '<-2<CR>gv=gv", "Move Up" },
      ["<S-Down>"] = { ":m '>+1<CR>gv=gv", "Move down" },
      ["<S-Up>"] = { ":m '<-2<CR>gv=gv", "Move Up" },

      ["<leader>y"] = { '"+y', "Yank to clipboard" },
      ["<leader>d"] = { '"_d', "Delete to void" },
    },
    x = {
      ["<leader>p"] = { '"_dP', "Paste" },
    },
  },
  trouble = {
    -- plugin = true,
    n = {
      ["<A-n>"] = { [[<cmd>lua require("trouble").next({skip_groups = true, jump = true})<CR>]], "Trouble next" },
      ["<A-m>"] = { [[<cmd>lua require("trouble").previous({skip_groups = true, jump = true})<CR>]], "Trouble prev" },
    },
  },
  cmake = {
    i = {
      ["<C-b>"] = { "<cmd> CMakeBuild <CR>", "CMake [b]uild" },
    },
    n = {
      ["<leader>cy"] = { "<cmd> CMakeSelectBuildType<CR>", "Select build type" },
      ["<leader>ct"] = { "<cmd> CMakeSelectBuildTarget <CR>", "Select CMake target" },
      ["<leader>cp"] = { "<cmd> CMakeSelectBuildPreset<CR>", "Select CMake preset" },
      ["<leader>cb"] = { "<cmd> CMakeBuild <CR>", "CMake build" },
      ["<leader>cs"] = { "<cmd> CMakeStop <CR>", "CMake stop" },
      ["<leader>cd"] = { "<cmd> CMakeDebug <CR>", "CMake debug" },
      ["<leader>ca"] = {
        function()
          local args = vim.fn.input "Command line args:"
          vim.cmd("CMakeLaunchArgs " .. args)
        end,
        "CMake launch args",
      },
      ["<C-b>"] = { "<cmd> CMakeBuild <CR>", "CMake build" },
      ["<leader>cr"] = { "<cmd> CMakeRun <CR>", "CMake run" },
      ["<C-r>"] = { "<cmd> CMakeRun <CR>", "CMake run" },
      ["<leader>cl"] = { "<cmd> CMakeSelectLaunchTarget <CR>", "CMake select launch target" },
      ["<leader>cqb"] = { "<cmd> CMakeQuickBuild <CR>", "CMake quick build" },
      ["<leader>cqd"] = { "<cmd> CMakeQuickDebug <CR>", "CMake quick debug" },
      ["<leader>cqr"] = { "<cmd> CMakeQuickRun <CR>", "CMake quick run" },
    },
  },
  perf = {
    n = {
      ["<leader>pr"] = { [[<cmd>lua RunPerf()<CR>]], "Run perf" },
      ["<leader>pa"] = { [[<cmd>lua AnalyzePerf()<CR>]], "Analyze Perf" },
      ["<leader>po"] = { [[<cmd>PerfToggleAnnotations<CR>]], "Toggle Perf" },
      ["<leader>pl"] = { [[<cmd>PerfHottestLines<CR>]], "Hottest Lines" },
      ["<leader>ps"] = { [[<cmd>PerfHottestSymbols<CR>]], "Hottest Symbols" },
      ["<leader>pf"] = { [[<cmd>PerfHottestCallersFunction<CR>]], "Hottest Callers" },
    },
  },
  gtest = {
    n = {
      ["<C-t>"] = { [[<cmd>GTestRunTestsuite<CR>]], "Run current Testsuite" },
      ["<leader>tc"] = { [[<cmd>GTestCancel<CR>]], "Cancel current test" },
      ["<leader>ts"] = { [[<cmd>GTestSelectAndRunTestsuite<CR>]], "Run Testsuite" },
      ["<leader>tt"] = { [[<cmd>GTestSelectAndRunTest<CR>]], "Run Test" },
    },
  },
  harpoon = {
    i = {
      ["<A-s>"] = {
        function()
          require("harpoon.ui").toggle_quick_menu()
        end,
        "Marked files",
      },
      ["<A-a>"] = {
        function()
          require("harpoon.mark").add_file()
        end,
        "Mark file",
      },
      ["<A-1>"] = {
        function()
          require("harpoon.ui").nav_file(1)
        end,
        "Navaigate to file",
      },
      ["<A-2>"] = {
        function()
          require("harpoon.ui").nav_file(2)
        end,
        "Navaigate to file",
      },
      ["<A-3>"] = {
        function()
          require("harpoon.ui").nav_file(3)
        end,
        "Navaigate to file",
      },
      ["<A-4>"] = {
        function()
          require("harpoon.ui").nav_file(4)
        end,
        "Navaigate to file",
      },
    },
    n = {
      ["<A-s>"] = {
        function()
          require("harpoon.ui").toggle_quick_menu()
        end,
        "Marked files",
      },
      ["<A-a>"] = {
        function()
          require("harpoon.mark").add_file()
        end,
        "Mark file",
      },
      ["<A-1>"] = {
        function()
          require("harpoon.ui").nav_file(1)
        end,
        "Navaigate to file",
      },
      ["<A-2>"] = {
        function()
          require("harpoon.ui").nav_file(2)
        end,
        "Navaigate to file",
      },
      ["<A-3>"] = {
        function()
          require("harpoon.ui").nav_file(3)
        end,
        "Navaigate to file",
      },
      ["<A-4>"] = {
        function()
          require("harpoon.ui").nav_file(4)
        end,
        "Navaigate to file",
      },
    },
  },
  macros = {
    i = {},
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
      ["<leader>fm"] = { "<cmd> Telescope marks <CR>", "Find marks" },
      ["<leader>ra"] = {
        function()
          require("nvchad_ui.renamer").open()
        end,
        "LSP rename",
      },
      ["<leader>dd"] = {
        function()
          vim.diagnostic.open_float { border = "rounded" }
        end,
        "Floating diagnostic",
      },
      ["<A-d>"] = {
        function()
          vim.diagnostic.open_float { border = "rounded" }
        end,
        "Floating diagnostic",
      },
      ["<leader>s"] = { [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "Replace under cursor" },

      ["<A-j>"] = { "<cmd>cnext<CR>zz", "Quickfix next" },
      ["<A-k>"] = { "<cmd>cprev<CR>zz", "Quickfix previous" },
      ["<leader>k"] = { "<cmd>lnext<CR>zz", "Location next" },
      ["<leader>j"] = { "<cmd>lprev<CR>zz", "Location previous" },
      ["<C-g>"] = {
        function()
          GitSignCodeAction()
        end,
        "Location previous",
      },

      ["<leader>gd"] = { "<cmd>Gitsigns diffthis<CR>", "git diff" },
      ["<leader>gq"] = { "<cmd>Gitsigns setqflist<CR>", "git diffs quickfix" },
      ["<leader>gv"] = { "<cmd>DiffviewOpen<CR>", "Open diff view" },
      ["<leader>gc"] = { "<cmd>DiffviewClose<CR>", "Close diff view" },
      ["<leader>gh"] = { "<cmd>DiffviewFileHistory %<CR>", "git history" },
      ["<leader>gl"] = { "<cmd>LazyGit<CR>", "LazyGit" },
      ["-"] = { [[<cmd>Oil<CR>]], "Oil" },

      ["<leader>qc"] = { "<cmd>cclose<CR>", "Quickfix close" },
      ["<leader>qv"] = { "<cmd>cclose<CR><cmd>vert copen 100<CR>", "Quickfix open vertical" },
      ["<leader>qb"] = { "<cmd>cclose<CR><cmd>bot copen 12<CR>", "Quickfix open bottom" },
    },

    v = {
      ["<leader>s"] = { [[:s///<Left><Left>]], "Replace within selection" },
      ["<leader>r"] = { [[y:%s/<C-R>=escape(@",'/\:.')<esc>//g<Left><Left>]], "Replace selection" },

      ["<C-p>"] = { ":diffput<CR>", "Move diff of other view" },
    },
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
    },
  },
  undotree = {
    n = {
      ["<leader>u"] = { vim.cmd.UndotreeToggle, "Undotree" },
    },
  },
  dap = {

    n = {
      ["<F5>"] = {
        function()
          require("dap").continue()
        end,
        "continue",
      },
      ["<F9>"] = {
        function()
          require("dap").toggle_breakpoint()
        end,
        "toogle breakpoint",
      },
      ["<F10>"] = {
        function()
          require("dap").step_over()
        end,
        "step over",
      },
      ["<leader><F10>"] = {
        function()
          require("dap").run_to_cursor()
        end,
        "Run to cursor",
      },
      ["<F12>"] = {
        function()
          require("dap").step_into()
        end,
        "step into",
      },
      ["<S-F12>"] = {
        function()
          require("dap").step_out()
        end,
        "step out",
      },
      ["<F11>"] = {
        function()
          require("dap").step_into()
        end,
        "step into",
      },
      ["<S-F11>"] = {
        function()
          require("dap").step_out()
        end,
        "step out",
      },

      ["<leader>di"] = {
        function()
          require("dap").step_into()
        end,
        "step into",
      },
      ["<leader>do"] = {
        function()
          require("dap").step_out()
        end,
        "step out",
      },
      ["<leader>du"] = {
        function()
          require("dapui").toggle()
        end,
        "Toggle Debug UI",
      },
      ["<leader>dq"] = {
        function()
          require("dap").terminate()
        end,
        "Stop debugging",
      },
      ["<leader>db"] = {
        function()
          require("dap").pause()
        end,
        "Pause",
      },
      ["<leader>dc"] = {
        function()
          require("dap").clear_breakpoints()
        end,
        "Clear breakpoints",
      },
      ["<leader>dl"] = {
        function()
          require("dap").list_breakpoints()
        end,
        "List breakpoints",
      },
      ["<leader>dr"] = {
        function()
          require("dap").repl.toggle()
        end,
        "Open repl",
      },
      ["<leader>dh"] = {
        function()
          require("dap.ui.widgets").hover()
        end,
        "Hover",
      },
      ["<leader>dp"] = {
        function()
          require("dap.ui.widgets").preview()
        end,
        "Preview",
      },
      ["<leader>dt"] = {
        function()
          local w = require "dap.ui.widgets"
          w.centered_float(w.threads)
        end,
        "Stack frames",
      },
      ["<leader>df"] = {
        function()
          local w = require "dap.ui.widgets"
          w.centered_float(w.frames)
        end,
        "Stack frames",
      },
      ["<leader>ds"] = {
        function()
          local w = require "dap.ui.widgets"
          w.centered_float(w.scopes)
        end,
        "Variables in Scope",
      },
      ["<leader>dot"] = {
        function()
          local w = require "dap.ui.widgets"
          w.sidebar(w.threads).open()
        end,
        "Threds in sidebar",
      },
      ["<leader>dof"] = {
        function()
          local w = require "dap.ui.widgets"
          w.sidebar(w.frames).open()
        end,
        "Stack frames sidebar",
      },
      ["<leader>dos"] = {
        function()
          local w = require "dap.ui.widgets"
          w.sidebar(w.scopes).open()
        end,
        "Variables in Scope sidebar",
      },
    },
  },
}

return M
