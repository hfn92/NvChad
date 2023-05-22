
local plugins = {
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        mappings = {
          i = {
            ["<A-q>"] = require "telescope.actions".send_to_qflist + require "telescope.actions".open_qflist,
            ["<A-S-q>"] = require "telescope.actions".send_selected_to_qflist + require "telescope.actions".open_qflist
          },
          n = {
            ["<A-q>"] = require "telescope.actions".send_to_qflist + require "telescope.actions".open_qflist,
            ["<A-S-q>"] = require "telescope.actions".send_selected_to_qflist + require "telescope.actions".open_qflist
          },
        },
      },
    },
  },
  {
    "lukas-reineke/lsp-format.nvim",
    config = function()
       require("lsp-format").setup{}
     end,
  },
  {
    "neovim/nvim-lspconfig",

    dependencies = {
      "jose-elias-alvarez/null-ls.nvim",
      config = function()
        require "custom.configs.null-ls"
      end,
    },

    config = function()
      require "plugins.configs.lspconfig"
       require "custom.configs.lspconfig"
     end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "cpp", "c", "cmake", "glsl" },
    },
  },
  {
    "Civitasv/cmake-tools.nvim",
    lazy=false,
    config = function()
      require("cmake-tools").setup
      {
        cmake_command = "cmake",
        cmake_build_directory = "",
        cmake_build_directory_prefix = "../build_", -- when cmake_build_directory is "", this option will be activated
        cmake_generate_options = { "-D", "CMAKE_EXPORT_COMPILE_COMMANDS=1" },
        cmake_regenerate_on_save = true, -- Saves CMakeLists.txt file only if mofified.
        cmake_launch_from_built_binary_directory = true, -- WIP: see #47 and #34
        cmake_soft_link_compile_commands = true, -- if softlink compile commands json file
        cmake_build_options = { "-j32" },
        cmake_console_size = 10, -- cmake output window height
        cmake_console_position = "belowright", -- "belowright", "aboveleft", ...
        cmake_show_console = "always", -- "always", "only_on_error"
        cmake_dap_configuration =
          {
            name = "cpp",
            type = "lldb",
            request = "launch",
            initCommands = function ()
              local script_import = 'command script import /home/fab/.conan/data/llvm-core/13.0.0/_/_/source/source/utils/lldbDataFormatters.py'
              local cmds = {}
              table.insert(cmds, script_import)
              table.insert(cmds, [[type summary add -w llvm e -s "size=${svar%#}" -x ^llvm::SmallVector<.+,.+>$]])
              table.insert(cmds, [[type summary add -s "[${var.x}, ${var.y}]" -x glm::vec<2]])
              table.insert(cmds, [[type summary add -s "[${var.x}, ${var.y}, ${var.z}]" -x glm::vec<3]])
              table.insert(cmds, [[type summary add -s "[${var.x}, ${var.y}, ${var.z}, ${var.w}]" -x glm::vec<4]])
              table.insert(cmds, [[type summary add -s "[${var.Left}, ${var.Top}, ${var.Width}, ${var.Height}]" -x Rect<]])
              return cmds
            end
          }, -- dap configuration, optional
        cmake_variants_message = {
          short = { show = true },
          long = { show = true, max_length = 40 }
        }
      }
    end,
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require('dap')

      dap.adapters.lldb = {
        type = 'executable',
        command = '/usr/bin/lldb-vscode', -- adjust as needed, must be absolute path
        name = 'lldb',
      }

      dap.adapters.codelldb = {
        type = 'server',
        port = "${port}",
        executable = {
          -- CHANGE THIS to your path!
          command = '/home/fab/Desktop/codelldb-x86_64-linux.vsix_FILES/extension/adapter/codelldb',
          args = {"--port", "${port}"},

          -- On windows you may have to uncomment this:
          -- detached = false,
        }
      }
      dap.configurations.cpp = {
        {
          name = 'launch',
          type = 'codelldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
          runInTerminal = true,
        },
      }
      dap.configurations.c = dap.configurations.cpp
      dap.configurations.rust = dap.configurations.cpp

    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    lazy = false,
    config = function()
      require("nvim-dap-virtual-text").setup {
        enabled = true,                        -- enable this plugin (the default)
        enabled_commands = true,               -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
        highlight_changed_variables = true,    -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
        highlight_new_as_changed = false,      -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
        show_stop_reason = true,               -- show stop reason when stopped for exceptions
        commented = false,                     -- prefix virtual text with comment string
        only_first_definition = true,          -- only show virtual text at first definition (if there are multiple)
        all_references = false,                -- show virtual text on all all references of the variable (not only definitions)
        display_callback = function(variable, _buf, _stackframe, _node)
          return variable.value
        end,

        -- experimental features:
        virt_text_pos = 'eol',                 -- position of virtual text, see `:h nvim_buf_set_extmark()`
        all_frames = false,                    -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
        virt_lines = false,                    -- show virtual lines instead of virtual text (will flicker!)
        virt_text_win_col = nil                -- position the virtual text at a fixed window column (starting from the first text column) ,
        -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
      }
    end,
  },
  {
    'rcarriga/nvim-dap-ui',
    config = function()
      require("dapui").setup()
    end,
  },
  {
    'ray-x/lsp_signature.nvim',
    config = function ()
      require("lsp_signature").setup({
        -- add any options here, or leave empty to use the default settings
      })
    end
  },
  -- {
  --   'github/copilot.vim',
  --   lazy = false,
  -- },
  {
    'mbbill/undotree',
    lazy = false,
  }
}
return plugins
