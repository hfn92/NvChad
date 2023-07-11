
local plugins = {
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      -- extensions = { ["ui-select"] = {require("telescope.themes").get_cursor { } }  },
      defaults = {
        mappings = {
          i = {
            ["<A-q>"] = require "telescope.actions".send_to_qflist + require "telescope.actions".open_qflist,
            ["<A-S-q>"] = require "telescope.actions".send_selected_to_qflist + require "telescope.actions".open_qflist,
            ["<A-a>"] = require "telescope.actions".add_to_qflist + require "telescope.actions".open_qflist,
            ["<A-S-a>"] = require "telescope.actions".add_selected_to_qflist + require "telescope.actions".open_qflist
          },
          n = {
            ["<A-q>"] = require "telescope.actions".send_to_qflist + require "telescope.actions".open_qflist,
            ["<A-S-q>"] = require "telescope.actions".send_selected_to_qflist + require "telescope.actions".open_qflist,
            ["<A-a>"] = require "telescope.actions".add_to_qflist + require "telescope.actions".open_qflist,
            ["<A-S-a>"] = require "telescope.actions".add_selected_to_qflist + require "telescope.actions".open_qflist
          },
        },
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function ()
      require("mason-lspconfig").setup()
    end,
    lazy=false
  },
  {
    "ThePrimeagen/harpoon",
    config = function ()
      require("harpoon").setup({})
      require("telescope").load_extension('harpoon')
    end,
    lazy=false
  },
  {
    "chentoast/marks.nvim",
    lazy=false,
    config = function ()
      require("marks").setup({})
    end
  },
  {
    'stevearc/oil.nvim',
    opts = {},
    cmd = { "Oil" },
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function ()
      require("oil").setup()
    end
  },
  {
    "lukas-reineke/lsp-format.nvim",
    config = function()
      require("lsp-format").setup{}
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    lazy=false,
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },

  { "folke/neodev.nvim", opts = {}, lazy=false,
    config = function ()
      require("neodev").setup({
        -- add any options here, or leave empty to use the default settings
      })
    end
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
    "sindrets/diffview.nvim",
    config = function ()
      require("diffview").setup({view = { merge_tool = { layout = "diff3_mixed" } } });
    end,
    lazy=false,
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
    "hfn92/cmake-gtest.nvim",
    lazy=false,
    --  dir = '/home/fab/Desktop/cmake-gtest.nvim/',
    --   -- dev=true,
    --   lazy=false,
    --   config = function()
    --      require("cmake-gtest").setup{}
    --    end,
  },
  {
    "Civitasv/cmake-tools.nvim",
    -- "hfn92/cmake-tools.nvim",
    -- branch="CmakeModelInfoMerge",
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
        -- cmake_quickfix_opts = { -- quickfix settings for cmake, quickfix will be used when `cmake_always_use_terminal` is false
        --   show = "always", -- "always", "only_on_error"
        --   position = "vert", -- "bottom", "top"
        --   size = 50,
        -- },
        cmake_dap_configuration =
          {
            name = "cpp",
            type = "codelldb",
            request = "launch",
            stopOnEntry = false,
            runInTerminal = false,
            initCommands = function ()
              local script_import = 'command script import /home/fab/.conan/data/llvm-core/13.0.0/_/_/source/source/utils/lldbDataFormatters.py'
              local cmds = {}
              table.insert(cmds, script_import)
              table.insert(cmds, [[type summary add -s "size=${svar%#}" -x ^llvm::SmallVector<.+,.+>$]])
              table.insert(cmds, [[type summary add -s "[${var.x}, ${var.y}]" -x ^glm::vec<2.*>$]])
              table.insert(cmds, [[type summary add -s "[${var.x}, ${var.y}, ${var.z}]" -x ^glm::vec<3.*>$]])
              table.insert(cmds, [[type summary add -s "[${var.x}, ${var.y}, ${var.z}, ${var.w}]" -x ^glm::vec<4.*>$]])
              table.insert(cmds, [[type summary add -s "[${var.Left}, ${var.Top}, ${var.Width}, ${var.Height}]" -x ^Rect<.+>$]])
              table.insert(cmds, [[type summary add -s "[${var.r%u}, ${var.g%u}, ${var.b%u}, ${var.a%u}]" Color]])
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

      local mason_registry = require("mason-registry")
      local codelldb = mason_registry.get_package("codelldb") -- note that this will error if you provide a non-existent package name

      dap.adapters.codelldb = {
        stopOnEntry = false,
        type = 'server',
        port = "${port}",
        executable = {
          -- CHANGE THIS to your path!
          -- command = '/home/fab/Desktop/codelldb-x86_64-linux.vsix_FILES/extension/adapter/codelldb',
          command = codelldb:get_install_path() .. "/extension/adapter/codelldb",
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
          runInTerminal = false,
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
      require("dapui").setup({
        layouts = {
          {
            elements = {
              { id = "repl", size = 0.25 },
              { id = "console", size = 0.25 },
              { id = "stacks", size = 0.35 },
              { id = "breakpoints", size = 0.15 },
            },
            position = "bottom",
            size = 14
          },
          {
            elements = {
              { id = "scopes", size = 0.85 },
              { id = "watches", size = 0.15 },
            },
            position = "left",
            size = 80
          },
        },

      })
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
