local plugins = {
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      -- extensions = { ["ui-select"] = {require("telescope.themes").get_cursor { } }  },
      defaults = {
        mappings = {
          i = {
            ["<A-q>"] = require("telescope.actions").send_to_qflist + require("telescope.actions").open_qflist,
            ["<A-S-q>"] = require("telescope.actions").send_selected_to_qflist
              + require("telescope.actions").open_qflist,
            ["<A-a>"] = require("telescope.actions").add_to_qflist + require("telescope.actions").open_qflist,
            ["<A-S-a>"] = require("telescope.actions").add_selected_to_qflist
              + require("telescope.actions").open_qflist,
          },
          n = {
            ["<A-q>"] = require("telescope.actions").send_to_qflist + require("telescope.actions").open_qflist,
            ["<A-S-q>"] = require("telescope.actions").send_selected_to_qflist
              + require("telescope.actions").open_qflist,
            ["<A-a>"] = require("telescope.actions").add_to_qflist + require("telescope.actions").open_qflist,
            ["<A-S-a>"] = require("telescope.actions").add_selected_to_qflist
              + require("telescope.actions").open_qflist,
          },
        },
      },
    },
  },
  {
    "t-troebst/perfanno.nvim",
    config = function()
      local util = require "perfanno.util"
      local bgcolor = vim.fn.synIDattr(vim.fn.hlID "Normal", "bg", "gui")
      require("perfanno").setup {
        -- Creates a 10-step RGB color gradient beween bgcolor and "#CC3300"
        line_highlights = util.make_bg_highlights(bgcolor, "#CC3300", 10),
        vt_highlight = util.make_fg_highlight "#CC3300",

        -- Automatically annotate files after :PerfLoadFlat and :PerfLoadCallGraph
        annotate_after_load = true,
        -- Automatically annotate newly opened buffers if information is available
        annotate_on_open = true,

        get_path_callback = function()
          local cmake = require "cmake-tools"
          local target = cmake.get_launch_target()
          local res = ""
          cmake.get_cmake_launch_targets(function(targets_res)
            if targets_res == nil then
              vim.cmd "CMakeGenerate"
              if targets_res == nil then
                return
              end
            end
            local targets, targetPaths = targets_res.data.targets, targets_res.data.abs_paths
            for idx, itarget in ipairs(targets) do
              if itarget == target then
                res = vim.fn.fnamemodify(targetPaths[idx], ":h") .. "/perf.data"
              end
            end
          end)
          return res
        end,
      }
    end,
    cmd = "PerfLoadCallGraph",
  },
  {
    "andythigpen/nvim-coverage",
    cmd = { "CoverageLoadLcov" },
    config = function()
      require("coverage").setup {
        signs = {
          covered = { hl = "CoverageCovered", text = "▎" },
          uncovered = { hl = "CoverageUncovered", text = "X" },
          partial = { hl = "CoverageCovered", text = "▎" },
        },

        load_coverage_cb = function(ftype)
          vim.notify("Loaded " .. ftype .. " coverage")
        end,
      }
    end,
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      use_diagnostic_signs = true,
    },
  },
  {
    "nvimdev/lspsaga.nvim",
    cmd = "Lspsaga",
    config = function()
      require("lspsaga").setup {
        symbols_in_winbar = { enable = false },
        code_action = {
          num_shortcut = true,
          extend_gitsigns = true,
        },
        lightbulb = {
          enable = false,
        },
      }
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup()
    end,
    lazy = false,
  },
  {
    "ThePrimeagen/harpoon",
    config = function()
      require("harpoon").setup {}
      require("telescope").load_extension "harpoon"
    end,
    lazy = false,
  },
  {
    "chentoast/marks.nvim",
    lazy = false,
    config = function()
      require("marks").setup {}
    end,
  },
  {
    "stevearc/oil.nvim",
    opts = {},
    cmd = { "Oil" },
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup {
        view_options = {
          -- Show files and directories that start with "."
          show_hidden = true,
        },
      }
    end,
  },
  {
    "lukas-reineke/lsp-format.nvim",
    config = function()
      require("lsp-format").setup {}
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    lazy = false,
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },

  {
    "folke/neodev.nvim",
    opts = {
      library = {
        enabled = true, -- when not enabled, neodev will not change any settings to the LSP server
        -- these settings will be used for your Neovim config directory
        runtime = true, -- runtime path
        types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
        plugins = true, -- installed opt or start plugins in packpath
        -- you can also specify the list of plugins to make available as a workspace library
        -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
      },
    },
    ft = { "lua" },
    config = function()
      require("neodev").setup {}
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
    "sindrets/diffview.nvim",
    config = function()
      require("diffview").setup { view = { merge_tool = { layout = "diff3_mixed" } } }
    end,
    lazy = false,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "cpp", "c", "cmake", "glsl", "markdown", "markdown_inline", "python" },
    },
  },
  {
    "hfn92/qf-virtual-text.nvim",
    -- dir = "/home/fab/Work/nvim/qf-virtual-text.nvim/",
    -- dev = true,
    lazy = false,
    -- on cfopen?
    config = function()
      require("qf-virtual-text").setup {}
    end,
  },
  {
    "hfn92/cmake-gtest.nvim",
    lazy = false,
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
    -- branch = "vim-notify-support",
    lazy = false,
    config = function()
      require("cmake-tools").setup {
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
        cmake_show_console = "only_on_error", -- "always", "only_on_error"
        cmake_quickfix_opts = { -- quickfix settings for cmake, quickfix will be used when `cmake_always_use_terminal` is false
          show = "only_on_error", -- "always", "only_on_error"
          -- position = "vert", -- "bottom", "top"
          -- size = 50,
        },
        cmake_dap_configuration = {
          name = "cpp",
          type = "codelldb",
          request = "launch",
          stopOnEntry = false,
          runInTerminal = false,
          initCommands = function()
            local script_import =
              "command script import /home/fab/.conan/data/llvm-core/13.0.0/_/_/source/source/utils/lldbDataFormatters.py"
            local cmds = {}
            table.insert(cmds, script_import)
            table.insert(cmds, [[type summary add -s "size=${svar%#}" -x ^llvm::SmallVector<.+,.+>$]])
            table.insert(cmds, [[type summary add -s "[${var.x}, ${var.y}]" -x ^glm::vec<2.*>$]])
            table.insert(cmds, [[type summary add -s "[${var.x}, ${var.y}, ${var.z}]" -x ^glm::vec<3.*>$]])
            table.insert(cmds, [[type summary add -s "[${var.x}, ${var.y}, ${var.z}, ${var.w}]" -x ^glm::vec<4.*>$]])
            table.insert(
              cmds,
              [[type summary add -s "[${var.Left}, ${var.Top}, ${var.Width}, ${var.Height}]" -x ^Rect<.+>$]]
            )
            table.insert(cmds, [[type summary add -s "[${var.r%u}, ${var.g%u}, ${var.b%u}, ${var.a%u}]" Color]])
            table.insert(cmds, [[settings set target.process.thread.step-avoid-regexp '']])
            return cmds
          end,
        }, -- dap configuration, optional
        cmake_variants_message = {
          short = { show = true },
          long = { show = true, max_length = 40 },
        },
      }
    end,
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require "dap"

      dap.adapters.lldb = {
        type = "executable",
        command = "/usr/bin/lldb-vscode", -- adjust as needed, must be absolute path
        name = "lldb",
      }

      local mason_registry = require "mason-registry"
      local codelldb = mason_registry.get_package "codelldb" -- note that this will error if you provide a non-existent package name

      dap.adapters.codelldb = {
        stopOnEntry = false,
        type = "server",
        port = "${port}",
        executable = {
          -- CHANGE THIS to your path!
          -- command = '/home/fab/Desktop/codelldb-x86_64-linux.vsix_FILES/extension/adapter/codelldb',
          command = codelldb:get_install_path() .. "/extension/adapter/codelldb",
          args = { "--port", "${port}" },

          -- On windows you may have to uncomment this:
          -- detached = false,
        },
      }
      dap.configurations.cpp = {
        {
          name = "launch",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
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
        enabled = true, -- enable this plugin (the default)
        enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
        highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
        highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
        show_stop_reason = true, -- show stop reason when stopped for exceptions
        commented = false, -- prefix virtual text with comment string
        only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
        all_references = false, -- show virtual text on all all references of the variable (not only definitions)
        display_callback = function(variable, _buf, _stackframe, _node)
          return variable.value
        end,

        -- experimental features:
        virt_text_pos = "eol", -- position of virtual text, see `:h nvim_buf_set_extmark()`
        all_frames = true, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
        virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
        virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
        -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
      }
    end,
  },
  {
    -- "rcarriga/nvim-dap-ui",
    "hfn92/nvim-dap-ui",
    branch = "repl-watches",
    config = function()
      require("dapui").setup {
        layouts = {
          {
            elements = {
              { id = "repl", size = 0.25 },
              { id = "console", size = 0.25 },
              { id = "stacks", size = 0.35 },
              { id = "breakpoints", size = 0.15 },
            },
            position = "bottom",
            size = 14,
          },
          {
            elements = {
              { id = "scopes", size = 0.85 },
              { id = "watches", size = 0.15 },
            },
            position = "left",
            size = 80,
          },
        },
      }
    end,
  },
  {
    "ray-x/lsp_signature.nvim",
    config = function()
      require("lsp_signature").setup {
        -- add any options here, or leave empty to use the default settings
      }
    end,
  },
  {
    -- "gaving/vim-textobj-argument",
    "inkarkat/argtextobj.vim",
    lazy = false,
  },
  {
    "mbbill/undotree",
    lazy = false,
  },
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    build = "cd app && npm install && git reset --hard",
  },
  {
    "rcarriga/nvim-notify",
    lazy = false,
    config = function()
      vim.notify = require "notify"
      -- require("notify").history()
      local info = "#a4b595"
      local error = "#cc6666"
      local warn = "#DE935F"
      vim.api.nvim_set_hl(0, "NotifyERRORBorder", { fg = error })
      vim.api.nvim_set_hl(0, "NotifyWARNBorder", { fg = "#79491D" })
      vim.api.nvim_set_hl(0, "NotifyINFOBorder", { fg = "#4F6752" })
      vim.api.nvim_set_hl(0, "NotifyDEBUGBorder", { fg = "#8B8B8B" })
      vim.api.nvim_set_hl(0, "NotifyTRACEBorder", { fg = "#4F3552" })
      vim.api.nvim_set_hl(0, "NotifyERRORIcon", { fg = error })
      vim.api.nvim_set_hl(0, "NotifyWARNIcon", { fg = warn })
      vim.api.nvim_set_hl(0, "NotifyINFOIcon", { fg = info })
      vim.api.nvim_set_hl(0, "NotifyDEBUGIcon", { fg = "#8B8B8B" })
      vim.api.nvim_set_hl(0, "NotifyTRACEIcon", { fg = "#D484FF" })
      vim.api.nvim_set_hl(0, "NotifyERRORTitle", { fg = error })
      vim.api.nvim_set_hl(0, "NotifyWARNTitle", { fg = warn })
      vim.api.nvim_set_hl(0, "NotifyINFOTitle", { fg = info })
      vim.api.nvim_set_hl(0, "NotifyDEBUGTitle", { fg = "#8B8B8B" })
      vim.api.nvim_set_hl(0, "NotifyTRACETitle", { fg = "#D484FF" })
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
    config = function()
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
    end,
  },
}
return plugins
