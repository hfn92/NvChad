local dap = require "dap"

dap.adapters.lldb = {
  type = "executable",
  command = "/usr/bin/lldb-vscode", -- adjust as needed, must be absolute path
  name = "lldb",
}

local mason_registry = require "mason-registry"
local codelldb = mason_registry.get_package "codelldb" -- note that this will error if you provide a non-existent package name

dap.adapters.codelldb = {
  stopOnEntry = false,
  type = "server",
  port = "${port}",
  executable = {
    command = codelldb:get_install_path() .. "/extension/adapter/codelldb",
    args = { "--port", "${port}" },

    -- On windows you may have to uncomment this:
    -- detached = false,
  },
}
dap.configurations.cpp = {
  {
    name = "launch",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {},
    runInTerminal = false,
  },
}
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

-- local wk = require "which-key"
--
-- local register_key = function()
--   wk.register({
--     ["J"] = {
--       function()
--         require("dap").run_to_cursor()
--       end,
--       "step over",
--     },
--     ["j"] = {
--       function()
--         require("dap").step_over()
--       end,
--       "step over",
--     },
--     ["k"] = {
--       function()
--         require("dap").step_into()
--       end,
--       "step into",
--     },
--     ["l"] = {
--       function()
--         require("dap").step_out()
--       end,
--       "step out",
--     },
--   }, { mode = "n" })
-- end
--
-- local unregister_key = function()
--   vim.cmd "unmap j"
--   vim.cmd "unmap k"
--   vim.cmd "unmap l"
--   wk.register({
--     ["J"] = { "mzJ`z", "Move next line back" },
--   }, { mode = "n" })
-- end
--
-- dap.listeners.after.event_initialized["dapui_config"] = function()
--   register_key()
-- end
-- dap.listeners.before.event_terminated["dapui_config"] = function()
--   unregister_key()
-- end
-- dap.listeners.before.event_exited["dapui_config"] = function()
--   unregister_key()
-- end
