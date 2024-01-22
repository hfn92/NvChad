vim.opt.colorcolumn = "120"
vim.opt.relativenumber = true
vim.opt.scrolloff = 12
vim.opt.smartindent = true
vim.opt.clipboard = ""

vim.filetype.add { extension = { fsh = "glsl" } }
vim.filetype.add { extension = { vsh = "glsl" } }
vim.filetype.add { extension = { gsh = "glsl" } }
vim.filetype.add { extension = { animation = "toml" } }
vim.filetype.add { extension = { ani = "lua" } }
--vim.filetype.add({ extension = { vsh = 'glsl' } })

vim.opt.fillchars:append { diff = "╱" }

vim.lsp.set_log_level "off"

-- vim.cmd([[
-- hi default link DapUINormal Normal
-- hi default link DapUIVariable Normal
-- hi default DapUIScope guifg=#00F1F5
-- hi default DapUIType guifg=#D484FF
-- hi default link DapUIValue Normal
-- hi default DapUIModifiedValue guifg=#00F1F5 gui=bold
-- hi default DapUIDecoration guifg=#00F1F5
-- hi default DapUIThread guifg=#A9FF68
-- hi default DapUIStoppedThread guifg=#00f1f5
-- hi default link DapUIFrameName Normal
-- hi default DapUISource guifg=#D484FF
-- hi default DapUILineNumber guifg=#00f1f5
-- hi default link DapUIFloatNormal NormalFloat
-- hi default DapUIFloatBorder guifg=#00F1F5
-- hi default DapUIWatchesEmpty guifg=#F70067
-- hi default DapUIWatchesValue guifg=#A9FF68
-- hi default DapUIWatchesError guifg=#F70067
-- hi default DapUIBreakpointsPath guifg=#00F1F5
-- hi default DapUIBreakpointsInfo guifg=#A9FF68
-- hi default DapUIBreakpointsCurrentLine guifg=#A9FF68 gui=bold
-- hi default link DapUIBreakpointsLine DapUILineNumber
-- hi default DapUIBreakpointsDisabledLine guifg=#424242
-- hi default link DapUICurrentFrameName DapUIBreakpointsCurrentLine
-- hi default DapUIStepOver guifg=#00f1f5
-- hi default DapUIStepInto guifg=#00f1f5
-- hi default DapUIStepBack guifg=#00f1f5
-- hi default DapUIStepOut guifg=#00f1f5
-- hi default DapUIStop guifg=#F70067
-- hi default DapUIPlayPause guifg=#A9FF68
-- hi default DapUIRestart guifg=#A9FF68
-- hi default DapUIUnavailable guifg=#424242
-- hi default DapUIWinSelect ctermfg=Cyan guifg=#00f1f5 gui=bold
-- hi default link DapUIEndofBuffer EndofBuffer
-- ]])

vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#993939", bg = "#31353f" })
vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = "#61afef", bg = "#31353f" })
vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379", bg = "#31353f" })
vim.api.nvim_set_hl(0, "GitSignsChange", { ctermbg = 0, fg = "#676e7b", bg = "#2E2F30" })
vim.api.nvim_set_hl(0, "GitSignsDeleteVirtLn", { ctermbg = 0, fg = "None", bg = "#542F2F" })

vim.api.nvim_set_hl(0, "DapUIType", { ctermbg = 0, fg = "#6B6D6E" })
vim.api.nvim_set_hl(0, "DapUILineNumber", { link = "Comment" })
vim.api.nvim_set_hl(0, "DapUIScope", { link = "Comment" })
vim.api.nvim_set_hl(0, "DapUIModifiedValue", { fg = "#FF8080" })
vim.api.nvim_set_hl(0, "DapUISource", { fg = "#98c379" })
vim.api.nvim_set_hl(0, "DapUIDecoration", { fg = "#98c379" }) -- |>
vim.api.nvim_set_hl(0, "DapUIBreakpointsInfo", { fg = "#98c379" })
vim.api.nvim_set_hl(0, "DapUIBreakpointsCurrentLine", { fg = "#98c379" })
-- vim.api.nvim_set_hl(0, "DapUIBreakpointsPath", { fg = "#6f8dab" })
-- vim.api.nvim_set_hl(0, "DapUIStoppedThread", { fg = "#6f8dab" })
vim.api.nvim_set_hl(0, "DapUIBreakpointsPath", { link = "Comment" })
vim.api.nvim_set_hl(0, "DapUIStoppedThread", { link = "Comment" })
vim.api.nvim_set_hl(0, "DapUIThread", { fg = "#6B6D6E" })
vim.api.nvim_set_hl(0, "DapUIStepOver", { fg = "#6f8dab" })
vim.api.nvim_set_hl(0, "DapUIStepInto", { fg = "#6f8dab" })
vim.api.nvim_set_hl(0, "DapUIStepBack", { fg = "#6f8dab" })
vim.api.nvim_set_hl(0, "DapUIStepOut", { fg = "#6f8dab" })
vim.api.nvim_set_hl(0, "DapUIPlayPause", { fg = "#98c379" })
vim.api.nvim_set_hl(0, "DapUIRestart", { fg = "#98c379" })
vim.api.nvim_set_hl(0, "DapUIStop", { fg = "#FF8080" })
vim.api.nvim_set_hl(0, "DapUIWatchesEmpty", { fg = "#6f8dab" })
vim.api.nvim_set_hl(0, "DapUIWatchesError", { fg = "#FF8080" })
vim.api.nvim_set_hl(0, "DapUI", { fg = "#FF8080" })
vim.api.nvim_set_hl(0, "DapUIVariable", { link = "Comment" })
vim.api.nvim_set_hl(0, "DapUIWatchesValue", { link = "Comment" })

vim.api.nvim_set_hl(0, "NvimDapVirtualTextChanged", { fg = "#FF8080" })

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint", numhl = "DapBreakpoint" })
vim.fn.sign_define("DapBreakpointCondition", { text = "ﳁ", texthl = "DapBreakpoint", numhl = "DapBreakpoint" })
vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DapBreakpoint", numhl = "DapBreakpoint" })
vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DapLogPoint", numhl = "DapLogPoint" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", numhl = "DapStopped" })

vim.api.nvim_set_hl(0, "DiffAdd", { fg = "#a4b595", bg = "#2a2b2b" })

-- local clr = require "custom.themes.fab"

local clr = {
  text = "#D6CF9A",
  text2 = "#D6BB9A",
  pink = "#ff9ca3",
  red = "#FF8080",
  keyword = "#9acfd6",
  -- keyword = "#45C6D6",
  -- keyword = "#5FACDE",
  -- keyword = "#497896",
  -- keyword = "#9aa7d6",
  -- keyword = "#FF8080",
  test = "#FF0000",
  grey = "#969896",
}

vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = "#FF8080" })

vim.api.nvim_set_hl(0, "@namespace.cpp", { ctermbg = 0, fg = clr.text })
vim.api.nvim_set_hl(0, "@type.qualifier.cpp", { ctermbg = 0, fg = clr.keyword })
vim.api.nvim_set_hl(0, "@property.cpp", { ctermbg = 0, fg = clr.text })
vim.api.nvim_set_hl(0, "@parameter.cpp", { ctermbg = 0, fg = clr.text })
vim.api.nvim_set_hl(0, "@constant.cpp", { ctermbg = 0, fg = clr.text })
vim.api.nvim_set_hl(0, "@Field.cpp", { ctermbg = 0, fg = clr.text })
vim.api.nvim_set_hl(0, "@constructor.cpp", { ctermbg = 0, fg = clr.text })
vim.api.nvim_set_hl(0, "@variable.builtin.cpp", { ctermbg = 0, fg = clr.keyword })
vim.api.nvim_set_hl(0, "@keyword.return.cpp", { ctermbg = 0, fg = clr.keyword })
vim.api.nvim_set_hl(0, "@keyword.cpp", { ctermbg = 0, fg = clr.keyword })
vim.api.nvim_set_hl(0, "@conditional.cpp", { ctermbg = 0, fg = clr.keyword })
vim.api.nvim_set_hl(0, "@repeat.cpp", { ctermbg = 0, fg = clr.keyword })
vim.api.nvim_set_hl(0, "@variable.cpp", { ctermbg = 0, fg = clr.text2 })
vim.api.nvim_set_hl(0, "@operator.cpp", { ctermbg = 0, fg = clr.text2 })

vim.api.nvim_set_hl(0, "qfFileName", { ctermbg = 0, fg = clr.text2 })
vim.api.nvim_set_hl(0, "qfLineNr", { ctermbg = 0, fg = clr.keyword })

vim.api.nvim_set_hl(0, "@function.builtin.cmake", { ctermbg = 0, fg = clr.text2 })
vim.api.nvim_set_hl(0, "@constant.cmake", { ctermbg = 0, fg = clr.red })

vim.api.nvim_set_hl(0, "@punctuation.special.markdown", { ctermbg = 0, fg = clr.red })

vim.api.nvim_set_hl(0, "@text.title.1.marker.markdown", { ctermbg = 0, fg = clr.keyword })
vim.api.nvim_set_hl(0, "@text.title.2.marker.markdown", { ctermbg = 0, fg = clr.keyword })
vim.api.nvim_set_hl(0, "@text.title.3.marker.markdown", { ctermbg = 0, fg = clr.keyword })
vim.api.nvim_set_hl(0, "@text.title.4.marker.markdown", { ctermbg = 0, fg = clr.keyword })
vim.api.nvim_set_hl(0, "@text.title.5.marker.markdown", { ctermbg = 0, fg = clr.keyword })

vim.api.nvim_set_hl(0, "@text.title.1.markdown", { ctermbg = 0, fg = clr.keyword })
vim.api.nvim_set_hl(0, "@text.title.2.markdown", { ctermbg = 0, fg = clr.keyword })
vim.api.nvim_set_hl(0, "@text.title.3.markdown", { ctermbg = 0, fg = clr.keyword })
vim.api.nvim_set_hl(0, "@text.title.4.markdown", { ctermbg = 0, fg = clr.keyword })
vim.api.nvim_set_hl(0, "@text.title.5.markdown", { ctermbg = 0, fg = clr.keyword })
vim.api.nvim_set_hl(0, "@text.title.5.markdown", { ctermbg = 0, fg = clr.keyword })

--vim.opt.runtimepath:prepend("/home/fab/Desktop/cmake-gtest.nvim")

vim.g.lua_snippets_path = vim.fn.stdpath "config" .. "/snippets"
