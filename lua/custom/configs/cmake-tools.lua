require("cmake-tools").setup {
  cmake_build_directory = "build/${variant:buildType}", -- this is used to specify generate directory for cmake
  cmake_regenerate_on_save = true, -- Saves CMakeLists.txt file only if mofified.
  cmake_soft_link_compile_commands = true, -- if softlink compile commands json file
  -- cmake_compile_commands_from_lsp = true,
  cmake_build_options = { "-j32" },

  cmake_executor = { -- executor to use
    name = "quickfix",
    default_opts = { -- a list of default and possible values for executors
      quickfix = {
        show = "only_on_error", -- "always", "only_on_error"
      },
    },
  },
  cmake_runner = {
    name = "overseer",

    opts = { -- a list of default and possible values for runners
      new_task_opts = {
        strategy = {
          "terminal",
          direction = "horizontal",
          autos_croll = true,
          quit_on_exit = "success",
        },
      }, -- options to pass into the `overseer.new_task` command
    },
  },

  cmake_dap_configuration = {
    name = "cpp",
    type = "codelldb",
    request = "launch",
    stopOnEntry = false,
    runInTerminal = false,
    initCommands = function()
      local cmds = {}

      local scan = require "plenary.scandir"
      local path = require "plenary.path"
      local dbh_path = path:new "./tools/debughelpers/lldb/"
      if dbh_path:exists() then
        local files = scan.scan_dir(dbh_path.filename, {})
        for _, v in ipairs(files) do
          table.insert(cmds, "command script import " .. v)
        end
      end

      local ok, res = pcall(function()
        return dofile "dap.lua"
      end)
      if ok then
        for _, v in ipairs(res) do
          table.insert(cmds, v)
        end
      end

      table.insert(cmds, [[settings set target.process.thread.step-avoid-regexp '']])
      table.insert(cmds, [[breakpoint name configure --disable cpp_exception]])
      return cmds
    end,
  },

  hooks = {
    on_progress = function(prog)
      -- vim.notify(vim.inspect(prog))
      require("progress_bar").progress {
        client_id = 999901,
        result = {
          token = 0,
          client = "cmake",
          value = prog,
        },
      }
      -- vim.notify(vim.inspect(prog))
    end,
  },
}
