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
