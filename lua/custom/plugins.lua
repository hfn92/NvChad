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
    lazy = false,
    cmd = "Lspsaga",
    config = function()
      require("lspsaga").setup {
        symbols_in_winbar = {
          enable = true,
          folder_level = 3,
        },
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
        columns = {
          "icon",
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
      ensure_installed = {
        "cpp",
        "c",
        "cmake",
        "glsl",
        "markdown",
        "markdown_inline",
        "python",
        "lua",
        "xml",
        "c_sharp",
      },
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
    -- config = function()
    --   require("cmake-gtest").setup {}
    -- end,
    config = function()
      require("cmake-gtest").setup {
        -- hooks = {
        --   ---@param testsuite string name of testsuite being run
        --   ---@param test string? name of the test being run. nil when whole testsuite is run
        --   ---@param cwd string working directory for command execution
        --   ---@param cmd string the command to execute
        --   ---@param args string[] function args
        --   ---@param env { [string] : string } environment variables
        --   run = function(testsuite, test, cwd, cmd, args, env)
        --     vim.notify("testsuite " .. vim.inspect(testsuite))
        --     vim.notify("test" .. vim.inspect(test))
        --     vim.notify("cwd " .. vim.inspect(cwd))
        --     vim.notify("cmd " .. vim.inspect(cmd))
        --     vim.notify("args " .. vim.inspect(args))
        --     vim.notify("env " .. vim.inspect(env))
        --   end,
        -- },
      }
    end,
  },
  {
    -- "Civitasv/cmake-tools.nvim",
    "hfn92/cmake-tools.nvim",
    branch = "overseer_terminal",
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
  -- {
  --   -- "gaving/vim-textobj-argument",
  --   "inkarkat/argtextobj.vim",
  --   lazy = false,
  -- },
  {
    "RRethy/nvim-treesitter-textsubjects",
    lazy = false,
    config = function()
      require("nvim-treesitter.configs").setup {
        textsubjects = {
          enable = true,
          prev_selection = ",", -- (Optional) keymap to select the previous selection
          keymaps = {
            ["."] = "textsubjects-smart",
            [";"] = "textsubjects-container-outer",
            ["i;"] = "textsubjects-container-inner",
          },
        },
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    lazy = false,
    config = function()
      require("nvim-treesitter.configs").setup {
        textobjects = {
          select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              -- ["at"] = "@type.inner",
              -- ["af"] = "@function.outer",
              -- ["if"] = "@function.inner",
              -- ["ac"] = "@class.outer",
              -- -- You can optionally set descriptions to the mappings (used in the desc parameter of
              -- -- nvim_buf_set_keymap) which plugins like which-key display
              -- ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
              -- -- You can also use captures from other query groups like `locals.scm`
              -- ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
            },
            -- You can choose the select mode (default is charwise 'v')
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * method: eg 'v' or 'o'
            -- and should return the mode ('v', 'V', or '<c-v>') or a table
            -- mapping query_strings to modes.
            -- selection_modes = {
            --   ["@parameter.outer"] = "v", -- charwise
            --   ["@function.outer"] = "V", -- linewise
            --   ["@class.outer"] = "<c-v>", -- blockwise
            -- },
            -- If you set this to `true` (default is `false`) then any textobject is
            -- extended to include preceding or succeeding whitespace. Succeeding
            -- whitespace has priority in order to act similarly to eg the built-in
            -- `ap`.
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * selection_mode: eg 'v'
            -- and should return true of false
            include_surrounding_whitespace = true,
          },
        },
      }
    end,
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
  -- {
  --   "rcarriga/nvim-notify",
  --   lazy = false,
  --   config = function()
  --     vim.notify = require "notify"
  --     -- require("notify").history()
  --     local info = "#a4b595"
  --     local error = "#cc6666"
  --     local warn = "#DE935F"
  --     vim.api.nvim_set_hl(0, "NotifyERRORBorder", { fg = error })
  --     vim.api.nvim_set_hl(0, "NotifyWARNBorder", { fg = "#79491D" })
  --     vim.api.nvim_set_hl(0, "NotifyINFOBorder", { fg = "#4F6752" })
  --     vim.api.nvim_set_hl(0, "NotifyDEBUGBorder", { fg = "#8B8B8B" })
  --     vim.api.nvim_set_hl(0, "NotifyTRACEBorder", { fg = "#4F3552" })
  --     vim.api.nvim_set_hl(0, "NotifyERRORIcon", { fg = error })
  --     vim.api.nvim_set_hl(0, "NotifyWARNIcon", { fg = warn })
  --     vim.api.nvim_set_hl(0, "NotifyINFOIcon", { fg = info })
  --     vim.api.nvim_set_hl(0, "NotifyDEBUGIcon", { fg = "#8B8B8B" })
  --     vim.api.nvim_set_hl(0, "NotifyTRACEIcon", { fg = "#D484FF" })
  --     vim.api.nvim_set_hl(0, "NotifyERRORTitle", { fg = error })
  --     vim.api.nvim_set_hl(0, "NotifyWARNTitle", { fg = warn })
  --     vim.api.nvim_set_hl(0, "NotifyINFOTitle", { fg = info })
  --     vim.api.nvim_set_hl(0, "NotifyDEBUGTitle", { fg = "#8B8B8B" })
  --     vim.api.nvim_set_hl(0, "NotifyTRACETitle", { fg = "#D484FF" })
  --   end,
  -- },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      -- "rcarriga/nvim-notify",
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
    "hfn92/gh.nvim",
    branch = "windows_support",
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
    "danymat/neogen",
    -- branch = "cpp_alt_comment_style",
    dependencies = "nvim-treesitter/nvim-treesitter",
    cmd = { "Neogen" },
    config = function()
      local i = require("neogen.types.template").item
      require("neogen").setup {
        snippet_engine = "luasnip",

        languages = {
          cpp = {
            template = {
              annotation_convention = "my_doxygen",
              my_doxygen = {
                { nil, "/// \\file", { no_results = true, type = { "file" } } },
                { nil, "/// \\brief $1", { no_results = true, type = { "func", "file", "class" } } },
                { nil, "", { no_results = true, type = { "file" } } },

                { i.ClassName, "/// \\class %s", { type = { "class" } } },
                { i.Type, "/// \\typedef %s", { type = { "type" } } },
                { nil, "/// \\brief $1", { type = { "func", "class", "type" } } },
                { i.Tparam, "/// \\tparam %s $1" },
                { i.Parameter, "/// \\param %s $1" },
                { i.Return, "/// \\return $1" },
              },
            },
          },
        },

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
  {
    "natecraddock/workspaces.nvim",
    lazy = false,
    config = function()
      require("workspaces").setup {}
      require("telescope").load_extension "workspaces"
    end,
  },
  -- {
  --   "nvim-treesitter/nvim-treesitter-context",
  --   lazy = false,
  --   config = function()
  --     require("treesitter-context").setup {
  --       enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  --       max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
  --       min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  --       line_numbers = true,
  --       multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
  --       trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  --       mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
  --       -- Separator between context and content. Should be a single character string, like '-'.
  --       -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
  --       separator = nil,
  --       zindex = 20, -- The Z-index of the context window
  --       on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
  --     }
  --   end,
  -- },
  -- {
  --   "Exafunction/codeium",
  --   lazy = false,
  --   config = function()
  --     vim.g.codeium_disable_bindings = true
  --     vim.g.codeium_no_map_tab = true
  --     vim.g["codeium_no_map_tab"] = 1
  --     vim.g.codeium_manual = true
  --     vim.keymap.set("i", "<C-a>", function()
  --       return vim.fn["codeium#Accept"]()
  --     end, { expr = true })
  --     vim.keymap.set("i", "<C-x>", function()
  --       return vim.fn["codeium#Complete"]()
  --     end, { expr = true })
  --   end,
  -- },
  -- {
  --   "chrisbra/vim-diff-enhanced",
  --   cmd = { "EnhancedDiff" },
  -- },
  {
    "stevearc/overseer.nvim",
    config = function()
      require("overseer").setup {
        templates = { "builtin", "user.conan_install_debug", "user.conan_install_reldeb" },
      }
    end,
    cmd = { "OverseerRun", "OverseerToggle", "OverseerQuickAction" },
  },
  -- {
  --   "ThePrimeagen/git-worktree.nvim",
  --   lazy = false,
  --   config = function()
  --     require("git-worktree").setup {}
  --     require("telescope").load_extension "git_worktree"
  --     local Worktree = require "git-worktree"
  --
  --     Worktree.on_tree_change(function(op, metadata)
  --       if op == Worktree.Operations.Switch then
  --         vim.cmd("CMakeSelectCmd " .. metadata.path)
  --         vim.notify("Git Worktree switched from " .. metadata.prev_path .. " to " .. metadata.path)
  --       end
  --       if op == Worktree.Operations.Created then
  --         vim.notify("Git Worktree created: " .. metadata.path .. " Branch:" .. metadata.branch)
  --       end
  --       if op == Worktree.Operations.Delete then
  --         vim.notify("Git Worktree deleted: " .. metadata.path)
  --       end
  --     end)
  --   end,
  -- },
  --
  --#region
  {
    dir = vim.fn.stdpath "config" .. "/plugins/decorator",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true,
    ft = { "cpp", "lua", "markdown" },
  },
  {
    dir = vim.fn.stdpath "config" .. "/plugins/progress_bar",
    dependencies = "folke/noice.nvim",
    config = function()
      require("progress_bar").setup {}
    end,
  },
  {
    "glacambre/firenvim",

    -- Lazy load firenvim
    -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
    lazy = not vim.g.started_by_firenvim,
    build = function()
      vim.fn["firenvim#install"](0)
    end,
  },
  -- {
  --   "ashfinal/qfview.nvim",
  --   event = "UIEnter",
  --   config = true,
  -- },
  -- {
  --   "kevinhwang91/nvim-bqf",
  --   lazy = false,
  --   config = function()
  --     require("bqf").setup()
  --     -- require("pqf").setup()
  --     -- require("pqf").setup {
  --     --   signs = {
  --     --     error = "E",
  --     --     warning = "W",
  --     --     info = "I",
  --     --     hint = "H",
  --     --   },
  --     --
  --     --   -- By default, only the first line of a multi line message will be shown. --
  --     --   -- When this is true, multiple lines will be shown for an entry, separated by a
  --     --   -- space
  --     --   show_multiple_lines = false,
  --     --
  --     --   -- How long filenames in the quickfix are allowed to be. 0 means no limit.
  --     --   -- Filenames above this limit will be truncated from the beginning with [...]
  --     -- max_filename_length = 0,
  --     -- }
  --   end,
  -- },
  -- {
  --   "yorickpeterse/nvim-pqf",
  --   lazy = false,
  --   config = function()
  --     -- require("pqf").setup()
  --     require("pqf").setup {
  --       signs = {
  --         error = "E",
  --         warning = "W",
  --         info = "I",
  --         hint = "H",
  --       },
  --
  --       -- By default, only the first line of a multi line message will be shown. --
  --       -- When this is true, multiple lines will be shown for an entry, separated by a
  --       -- space
  --       show_multiple_lines = false,
  --
  --       -- How long filenames in the quickfix are allowed to be. 0 means no limit.
  --       -- Filenames above this limit will be truncated from the beginning with [...]
  --       max_filename_length = 0,
  --     }
  --   end,
  -- },
  -- {
  --   "fole/styler.nvim",
  --   lazy = false,
  --   config = function()
  --     require("styler").setup {
  --       themes = {
  --         lua = { colorscheme = "gruvbox" },
  --         help = { colorscheme = "catppuccin-mocha", background = "dark" },
  --       },
  --     }
  --   end,
  -- },
}
return plugins
