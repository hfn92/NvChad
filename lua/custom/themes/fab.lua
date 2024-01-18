local M = {}

M.base_30 = {
  white = "#C5C8C2",
  darker_black = "#2A2B2B",
  black = "#2E2F30", -- nvim bg
  black2 = "#232527",
  one_bg = "#2d2f31",
  one_bg2 = "#353b45",
  -- one_bg2 = "#373737",
  one_bg3 = "#30343c",
  grey = "#6B6D6E", -- line number
  grey_fg = "#A8ABB0", -- comments
  grey_fg2 = "#616875",
  light_grey = "#676e7b", -- git signs?
  red = "#cc6666",
  baby_pink = "#FF6E79",
  pink = "#ff9ca3",
  line = "#3D3E40", -- for lines like vertsplit
  green = "#a4b595",
  vibrant_green = "#a3b991",
  nord_blue = "#728da8",
  blue = "#6f8dab", -- code action / icon color
  yellow = "#d7bd8d",
  sun = "#e4c180",
  purple = "#b4bbc8",
  dark_purple = "#b290ac",
  teal = "#8abdb6",
  orange = "#DE935F",
  cyan = "#70c0b1",
  statusline_bg = "#333436",
  lightbg = "#373B41",
  pmenu_bg = "#a4b595",
  folder_bg = "#6f8dab",
  test = "",
}

M._clr = {
  text = "#D6CF9A",
  text2 = "#D6BB9A",
  pink = "#ff9ca3",
  red = "#FF8080",
  -- blue = "#45C6D6",
  -- keyword = "#5FACDE",
  -- keyword = "#9aa7d6",
  -- keyword = "#45C6D6",
  keyword = "#9acfd6",
  test = "#FF0000",
}

local clr = M._clr

M.base_16 = {
  base00 = "#2E2F30", -- bg
  base01 = "#3B3C3C",
  base02 = "#1D545C", -- selection
  base03 = "#969896",
  base04 = "#b4b7b4",
  base05 = clr.text, -- text color
  base06 = "#e0e0e0",
  base07 = "#ffffff",
  base08 = clr.text,
  base09 = "#de935f",
  base0A = "#FF8080",
  base0B = "#D69545",
  -- base0C = "#8abeb7",
  base0C = clr.keyword,
  base0D = clr.text,
  base0E = clr.keyword,
  base0F = clr.text, -- parantheses ()
}

M.type = "dark"

M.polish_hl = {
  -- syntax-related highlight groups
  ["@type.builtin.cpp"] = { fg = M.base_30.purple },
  ["@keyword.cpp"] = { bg = M.base_30.purple },
}

return M
