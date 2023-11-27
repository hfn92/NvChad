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

local function traverse(node, lines)
  local ts = vim.treesitter

  if node:type() == "function_declaration" then
    local start_row, _, end_row, _ = ts.get_node_range(node)
    table.insert(lines, { start_row, start_row })
  end
  --
  -- if node:type() == "function_declarator" then
  --   local start_row, _, end_row, _ = ts.get_node_range(node)
  --   table.insert(lines, { start_row, end_row })
  -- end

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

  if node:type() == "class_specifier" then
    local decl = find(node, "field_declaration_list")
    local start_row, _, _, _ = ts.get_node_range(node)
    if decl then
      local end_row, _, _, _ = ts.get_node_range(decl)
      table.insert(lines, { start_row, end_row })
    end
  end

  for a = 0, node:named_child_count() - 1, 1 do
    traverse(node:named_child(a), lines)
  end
end

function M.Clear()
  local ns_id = vim.api.nvim_create_namespace "decorator"
  local buffer_id = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(buffer_id, ns_id, 0, -1)
end

function M.Test(bufnr)
  local parser = require("nvim-treesitter.parsers").get_parser(bufnr)
  if not parser then
    return
  end
  -- end
  local is = nil
  if parser then
    is = true
  end
  --
  local ts_utils = require "nvim-treesitter.ts_utils"
  local ts = vim.treesitter
  ts.get_parser()
  local current_node = vim.treesitter.get_parser(bufnr):parse()[1]:root()
  if not current_node then
    return ""
  end

  local lines = {}
  traverse(current_node, lines)
  -- vim.notify(vim.inspect(lines))

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

    -- pcall(function()
    -- end)

    -- local opts = {
    --   virt_lines_above = true,
    --   virt_lines = {
    --     {
    --       {
    --         "------------------------------------------------------------------------------------------------------------------------",
    --         -- "                                                                                                                        ",
    --         "FuncBg",
    --       },
    --     },
    --   },
    -- }
    --
    -- pcall(function()
    --   vim.api.nvim_buf_set_extmark(buffer_id, ns_id, value[1], 0, opts)
    -- end)
    --
    -- opts.virt_lines_above = false
    --
    -- pcall(function()
    --   vim.api.nvim_buf_set_extmark(buffer_id, ns_id, value[2], 0, opts)
    -- end)
  end
end

function M.init()
  M.group = vim.api.nvim_create_augroup("codedecorator", { clear = false })
  vim.api.nvim_create_autocmd("BufAdd", {
    group = M.group,
    callback = function(test)
      local parser = require("nvim-treesitter.parsers").get_parser(test.buf)
      -- end
      local is = nil
      if parser then
        is = true
      end

      -- vim.fn.bufload(test.buf)

      -- vim.defer_fn(function()
      --   M.Clear()
      --   M.Test(test.buf)
      -- end, 1000)

      -- vim.notify(vim.fn.bufname(test.buf) .. " " .. vim.inspect(is))
      -- vim.notify "hi"
      -- vim.notify(vim.fn.bufname(test.buf))
      -- vim.schedule_wrap(function() end)
      -- vim.notify(vim.inspect(test.buf))
      -- vim.notify(vim.fn.bufname(test.buf))
      vim.api.nvim_create_autocmd({ "TextChangedI", "TextChanged" }, {
        group = M.group,
        buffer = test.bufnr,
        callback = function(i)
          M.Clear()
          M.Test(i.buf)
        end,
      })
    end,
  })
end

function M.disable()
  vim.api.nvim_del_augroup_by_id(M.group)
  M.Clear()
end
return M
