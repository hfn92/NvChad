local m = require "decorator"

vim.api.nvim_create_user_command("DecoOn", m.init, {})
vim.api.nvim_create_user_command("DecoOff", m.disable, {})
