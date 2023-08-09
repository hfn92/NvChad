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
    -- "t-troebst/perfanno.nvim",
    "hfn92/perfanno.nvim",
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

        formats = {
          { percent = true, format = "%.2f%%", minimum = 0.5 },
          { percent = true, format = "%.2f%%", minimum = 0.1 },
          { percent = false, format = "%d", minimum = 1 },
        },

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
      require("mason-lspconfig").setup {
        ensure_installed = {
          "lua_ls",
          "clangd",
          "cmake",
          "pylsp",
        },
      }
    end,
    lazy = false,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
    config = function()
      require("mason-null-ls").setup {
        ensure_installed = {
          "stylua",
          "cmakelang",
          "markdownlint",
          "codelldb",
        },
      }
    end,
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
    lazy = false,
    -- ft = { "lua" },
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
    "hfn92/dissassembly.nvim",
    -- dir = "/home/fab/Work/nvim/dissassembly.nvim/",
    -- dev = true,
    cmd = { "DisassembleFunction", "DisassembleFile" },
    -- on cfopen?
    config = function()
      require("disassembly").setup {
        build_directory = function()
          local cmake = require "cmake-tools"
          return cmake.get_config().build_directory:expand()
        end,
        compile_commands_path = function()
          local cmake = require "cmake-tools"
          return cmake.get_config().build_directory:expand()
        end,
      }
    end,
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
      require "custom.configs.cmake-tools"
    end,
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      require "custom.configs.nvim-dap"
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    lazy = false,
    config = function()
      require "custom.configs.nvim-dap-virtual-text"
    end,
  },
  {
    -- "rcarriga/nvim-dap-ui",
    "hfn92/nvim-dap-ui",
    branch = "custom_scopes",
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
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require "custom.configs.noice"
    end,
  },
  {
    "ldelossa/litee.nvim",
    config = function()
      require("litee.lib").setup()
    end,
  },
  {
    "ldelossa/gh.nvim",
    dependencies = { "litee.nvim" },
    keys = "<leader>gb",
    config = function()
      require "custom.configs.gh"
    end,
  },
  {
    "nvim-treesitter/playground",
    cmd = { "TSPlaygroundToggle" },
  },
  {
    "hfn92/neogen",
    branch = "cpp_alt_comment_style",
    dependencies = "nvim-treesitter/nvim-treesitter",
    cmd = { "Neogen" },
    config = function()
      require("neogen").setup {
        snippet_engine = "luasnip",

        placeholders_text = {
          ["description"] = "",
          ["tparam"] = "",
          ["parameter"] = "",
          ["return"] = "",
          ["class"] = "",
          ["throw"] = "",
          ["varargs"] = "",
          ["type"] = "",
          ["attribute"] = "",
          ["args"] = "",
          ["kwargs"] = "",
        },
      }
    end,
    -- Uncomment next line if you want to follow only stable versions
    -- version = "*"
  },
}
return plugins
