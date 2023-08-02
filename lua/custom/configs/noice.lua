require("telescope").load_extension "noice"
require("noice").setup {
  lsp = {
    signature = { enabled = false },
    hover = {
      enabled = false,
      silent = false, -- set to true to not show a message if hover is not available
      view = nil, -- when nil, use defaults from documentation
      ---@type NoiceViewOptions
      opts = {}, -- merged with defaults from documentation
    },
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
      ["vim.lsp.util.stylize_markdown"] = false,
      ["cmp.entry.get_documentation"] = false,
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false, -- add a border to hover docs and signature help
  },
}
vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = "#3D3E40" })
vim.api.nvim_set_hl(0, "NoiceCmdlinePopupTitle", { fg = "#C5C8C2" })
vim.api.nvim_set_hl(0, "NoiceCmdlineIcon", { fg = "#C5C8C2" })
vim.api.nvim_set_hl(0, "NoiceCmdlineIconSearch", { fg = "#C5C8C2" })
