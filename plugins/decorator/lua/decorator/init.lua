local M = {}

local function find(node, type)
  local ts = vim.treesitter

  if node:type() == type then
    return node
  end

  for a = 0, node:named_child_count() - 1, 1 do
    local res = find(node:named_child(a), type)
    if res then
      return res
    end
  end
  return nil
end

function M.Clear()
  local ns_id = vim.api.nvim_create_namespace "decorator"
  local buffer_id = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(buffer_id, ns_id, 0, -1)
end

function M.decorate(bufnr, lines)
  local ns_id = vim.api.nvim_create_namespace "decorator"
  local buffer_id = vim.api.nvim_get_current_buf()

  vim.api.nvim_set_hl(0, "FuncBg", { ctermbg = 0, bg = "#2a2b2b" })
  vim.api.nvim_buf_clear_namespace(buffer_id, ns_id, 0, -1)
  for key, value in pairs(lines) do
    vim.highlight.range(buffer_id, ns_id, "FuncBg", { value[1], 0 }, { value[2], 120 })
    -- vim.api.nvim_buf_set_extmark(
    --   buffer_id,
    --   ns_id,
    --   value[1],
    --   0,
    --   { end_row = value[2] + 1, hl_group = "FuncBg", hl_eol = true, end_col = 0 }
    -- )
    --
    local opts = {
      virt_text_win_col = 13,
      -- virt_text_pos = "overlay",
      -- hl_mode = "combine",
      virt_text = {
        {
          "                                                                                                                        ",
          "FuncBg",
        },
      },
    }

    local lines = vim.api.nvim_buf_get_lines(bufnr, value[1], value[2] + 1, false)
    -- vim.notify(vim.inspect(lines))
    for i = value[1], value[2], 1 do
      -- vim.notify(vim.inspect(i - value[1] + 1))
      -- vim.notify(vim.inspect(lines[1]))
      opts.virt_text_win_col = #lines[i - value[1] + 1]
      local len = 120 - opts.virt_text_win_col
      -- print(len)
      if len > 0 then
        opts.virt_text[1][1] = string.rep(" ", len)
        vim.api.nvim_buf_set_extmark(buffer_id, ns_id, i, 0, opts)
      end
    end
  end
end

local cnt = 0

local parse_query_save = function(language, query)
  -- vim.treesitter.query.parse_query() is deprecated, use vim.treesitter.query.parse() instead
  local ok, parsed_query = pcall(vim.treesitter.query.parse, language, query)
  if not ok then
    print(parsed_query)
    return nil
  end
  return parsed_query
end

M.config = {
  cpp = {
    query = parse_query_save(
      "cpp",
      [[
[
(function_definition)
] @function

[
(class_specifier)
(struct_specifier)
] @class
]]
    ),
  },
}

local ts = vim.treesitter

function M.Test2(bufnr)
  local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
  local c = M.config[filetype]

  if not c or not c.query then
    return
  end

  local language_tree = vim.treesitter.get_parser(bufnr, filetype)
  local syntax_tree = language_tree:parse()
  local root = syntax_tree[1]:root()
  local win_view = vim.fn.winsaveview()

  local lines = {}
  for _, match, _ in c.query:iter_matches(root, bufnr) do
    for id, node in pairs(match) do
      local capture = c.query.captures[id]
      if node:type() == "function_declaration" then
        local start_row, _, end_row, _ = ts.get_node_range(node)
        table.insert(lines, { start_row, start_row })
      end

      if node:type() == "atx_heading" then
        local start_row, _, end_row, _ = ts.get_node_range(node)
        table.insert(lines, { start_row, start_row })
      end

      if node:type() == "function_definition" then
        local start_row, _, end_row, _ = ts.get_node_range(node)
        if start_row ~= end_row then
          local decl = find(node, "function_declarator")
          if decl then
            local start_row, _, end_row, _ = ts.get_node_range(decl)
            table.insert(lines, { start_row, end_row })
          end
        end
      end

      if node:type() == "class_specifier" or node:type() == "struct_specifier" then
        local decl = find(node, "field_declaration_list")
        local start_row, _, _, _ = ts.get_node_range(node)
        if decl then
          local end_row, _, _, _ = ts.get_node_range(decl)
          table.insert(lines, { start_row, end_row - 1 })
        end
      end
    end
  end
  M.decorate(bufnr, lines)
end

function M.init()
  -- print "init"
  M.group = vim.api.nvim_create_augroup("codedecorator", { clear = true })
  M.config = {
    cpp = {
      query = parse_query_save(
        "cpp",
        [[
[
(function_definition)
] @function

[
(class_specifier)
(struct_specifier)
] @class
]]
      ),
    },
    lua = {
      query = parse_query_save(
        "lua",
        [[
[
(function_declaration)
] @function
]]
      ),
    },
    markdown = {
      query = parse_query_save(
        "markdown",
        [[
[
(atx_heading)
] @function
]]
      ),
    },
  }

  vim.api.nvim_create_autocmd({ "FileChangedShellPost", "Syntax", "TextChanged", "TextChangedI", "InsertLeave" }, {
    group = M.group,
    -- pattern = { "cpp" },
    -- buffer = test.bufnr,
    callback = function(i)
      -- print "dec"
      -- local t = vim.loop.hrtime()
      M.Clear()
      M.Test2(i.buf)
      -- local dt = vim.loop.hrtime() - t
      -- print(cnt .. " " .. dt / 1000 / 1000)
      -- cnt = cnt + 1
    end,
  })
end

function M.setup()
  M.init()
end

function M.disable()
  vim.api.nvim_del_augroup_by_id(M.group)
  M.Clear()
end
return M
