vim.opt.colorcolumn = "120"
vim.opt.relativenumber = true
vim.opt.scrolloff = 12
vim.opt.smartindent = true
vim.opt.clipboard = ""

vim.filetype.add({ extension = { fsh = 'glsl' } })
vim.filetype.add({ extension = { vsh = 'glsl' } })
--vim.filetype.add({ extension = { vsh = 'glsl' } })

vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#993939', bg = '#31353f' })
vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef', bg = '#31353f' })
vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379', bg = '#31353f' })

vim.fn.sign_define('DapBreakpoint', { text='', texthl='DapBreakpoint', numhl='DapBreakpoint' })
vim.fn.sign_define('DapBreakpointCondition', { text='ﳁ', texthl='DapBreakpoint', numhl='DapBreakpoint' })
vim.fn.sign_define('DapBreakpointRejected', { text='', texthl='DapBreakpoint', numhl= 'DapBreakpoint' })
vim.fn.sign_define('DapLogPoint', { text='', texthl='DapLogPoint', numhl= 'DapLogPoint' })
vim.fn.sign_define('DapStopped', { text='', texthl='DapStopped', numhl= 'DapStopped' })

--vim.opt.runtimepath:prepend("/home/fab/Desktop/cmake-gtest.nvim")



vim.g.lua_snippets_path = vim.fn.stdpath "config" .. "/snippets"
