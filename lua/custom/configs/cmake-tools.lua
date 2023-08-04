require("cmake-tools").setup {
  cmake_command = "cmake",
  cmake_build_directory = "",
  cmake_build_directory_prefix = "../build_", -- when cmake_build_directory is "", this option will be activated
  cmake_generate_options = { "-D", "CMAKE_EXPORT_COMPILE_COMMANDS=1" },
  cmake_regenerate_on_save = true, -- Saves CMakeLists.txt file only if mofified.
  cmake_launch_from_built_binary_directory = true, -- WIP: see #47 and #34
  cmake_soft_link_compile_commands = true, -- if softlink compile commands json file
  cmake_build_options = { "-j32" },
  cmake_console_size = 10, -- cmake output window height
  cmake_console_position = "belowright", -- "belowright", "aboveleft", ...
  cmake_show_console = "only_on_error", -- "always", "only_on_error"
  cmake_quickfix_opts = { -- quickfix settings for cmake, quickfix will be used when `cmake_always_use_terminal` is false
    show = "only_on_error", -- "always", "only_on_error"
    -- position = "vert", -- "bottom", "top"
    -- size = 50,
  },
  cmake_dap_configuration = {
    name = "cpp",
    type = "codelldb",
    request = "launch",
    stopOnEntry = false,
    runInTerminal = false,
    initCommands = function()
      local cmds = {}

      local ok, res = pcall(function()
        return dofile "dap.lua"
      end)
      if ok then
        for _, v in ipairs(res) do
          table.insert(cmds, v)
        end
      end

      local scan = require "plenary.scandir"
      local path = require "plenary.path"
      local reply_directory = path:new "./tools/debughelpers/lldb/"
      if reply_directory:exists() then
        local files = scan.scan_dir(reply_directory.filename, {})
        for _, v in ipairs(files) do
          table.insert(cmds, "command script import " .. v)
        end
      end

      table.insert(cmds, [[settings set target.process.thread.step-avoid-regexp '']])
      table.insert(cmds, [[breakpoint name configure --disable cpp_exception]])
      return cmds
    end,
  }, -- dap configuration, optional
  cmake_variants_message = {
    short = { show = true },
    long = { show = true, max_length = 40 },
  },
}
