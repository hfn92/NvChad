return {
  name = "Conan install Release With Debug Info",
  builder = function()
    local path = require "plenary.path"
    local b_path = path:new "./build/"
    if not b_path:exists() then
      b_path:mkdir()
    end

    b_path = path:new "./build/RelWithDebInfo"
    if not b_path:exists() then
      b_path:mkdir()
    end
    -- Full path to current file (see :help expand())
    return {
      cmd = { "conan" },
      args = { "install", "../..", "-s", "build_type=RelWithDebInfo", "--build=missing" },
      cwd = "./build/RelWithDebInfo",
      components = { { "on_output_quickfix", open_on_exit = "failure" }, "default" },
    }
  end,
}
