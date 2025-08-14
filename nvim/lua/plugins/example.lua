-- since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore
-- if true then return {} end

-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins

vim.api.nvim_set_hl(0, "LualineProgressPodBody", { fg = "#000000", bg = "#A6ACCD" })

local function time_pod_progress_bar()
  local total_width = vim.o.columns
  local bar_width = total_width

  local time = os.date("*t")
  local total_minutes = time.hour * 60 + time.min
  local percent = total_minutes / (24 * 60)
  local pos = math.floor(bar_width * percent)

  local time_str = os.date(" %H:%M ")

  -- Define your highlight groups here or use existing ones
  local pod_edge_hl = "%#LualineProgressPodEdge#"
  local pod_body_hl = "%#LualineProgressPodBody#"
  local reset_hl = "%#Normal#"

  local before = string.rep("─", math.max(0, pos - 1))
  local after = string.rep("─", math.max(0, bar_width - pos - #time_str - 2))

  -- Compose the line with embedded highlights
  local line = before
    .. pod_edge_hl
    .. ""
    .. reset_hl
    .. pod_body_hl
    .. time_str
    .. reset_hl
    .. pod_edge_hl
    .. ""
    .. reset_hl
    .. after

  return line
end

return {
  -- add gruvbox
  -- { "ellisonleao/gruvbox.nvim" },
  { "marko-cerovac/material.nvim" },

  -- Configure LazyVim to load gruvbox
  -- {
  --   "LazyVim/LazyVim",
  --   opts = {
  --     -- colorscheme = "gruvbox",
  --     colorscheme = "material",
  --   },
  -- },

  -- change trouble config
  {
    "folke/trouble.nvim",
    -- opts will be merged with the parent spec
    opts = { use_diagnostic_signs = true },
  },

  -- add symbols-outline
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    config = true,
  },

  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup({
        -- your configuration comes here
        manual_mode = false,
      })
    end,
  },

  {
    "sindrets/diffview.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      {
        "dv",
        function()
          if next(require("diffview.lib").views) == nil then
            vim.cmd("DiffviewOpen")
          else
            vim.cmd("DiffviewClose")
          end
        end,
        desc = "Toggle Diffview window",
      },
    },
  },

  -- {
  --   "akinsho/git-conflict.nvim",
  --   version = "*",
  --   config = true,
  --   event = "BufReadPost",
  -- },
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  -- override nvim-cmp and add cmp-emoji
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")

      opts.snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      }
      opts.sources = cmp.config.sources(vim.tbl_extend("force", opts.sources, {
        { name = "luasnip" },
      }))
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },

  -- change some telescope options and a keymap to browse plugin files
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "ahmedkhalf/project.nvim",
    },
    keys = {
      {
        "<leader>fp",
        function()
          require("telescope.builtin").find_files({
            cwd = require("lazy.core.config").options.root,
          })
        end,
        desc = "Find Plugin File",
      },
    },
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
    config = function(_, opts)
      -- Apply the opts to telescope
      require("telescope").setup(opts)

      -- Setup the project.nvim plugin
      require("project_nvim").setup({})

      -- Load the projects extension AFTER project.nvim is setup
      require("telescope").load_extension("projects")
    end,
  },

  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    ft = "markdown",
    config = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  {
    "folke/zen-mode.nvim",
    keys = {
      {
        "<leader>z",
        function()
          local ft = vim.bo.filetype
          if ft == "snacks_picker_list" then
            -- Do nothing if in explorer
            return
          end
          vim.cmd("ZenMode")
        end,
        desc = "Toggle Zen mode",
      },
    },
    opts = {
      window = {
        backdrop = 0.95,
      },
      on_open = function()
        Snacks.picker.explorer()
      end,
      on_close = function()
        Snacks.picker.explorer()
      end,
    },
  },

  {
    "mfussenegger/nvim-dap",
    recommended = true,
    desc = "Debugging support.",

    dependencies = {
      "rcarriga/nvim-dap-ui",
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
    },

    keys = {
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Breakpoint Condition",
      },
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Run/Continue",
      },
      {
        "<leader>da",
        function()
          require("dap").continue({ before = get_args })
        end,
        desc = "Run with Args",
      },
      {
        "<leader>dC",
        function()
          require("dap").run_to_cursor()
        end,
        desc = "Run to Cursor",
      },
      {
        "<leader>dg",
        function()
          require("dap").goto_()
        end,
        desc = "Go to Line (No Execute)",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "Step Into",
      },
      {
        "<leader>dj",
        function()
          require("dap").down()
        end,
        desc = "Down",
      },
      {
        "<leader>dk",
        function()
          require("dap").up()
        end,
        desc = "Up",
      },
      {
        "<leader>dl",
        function()
          require("dap").run_last()
        end,
        desc = "Run Last",
      },
      {
        "<leader>do",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
      {
        "<leader>dO",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<leader>dP",
        function()
          require("dap").pause()
        end,
        desc = "Pause",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.toggle()
        end,
        desc = "Toggle REPL",
      },
      {
        "<leader>ds",
        function()
          require("dap").session()
        end,
        desc = "Session",
      },
      {
        "<leader>dt",
        function()
          require("dap").terminate()
        end,
        desc = "Terminate",
      },
      {
        "<leader>dw",
        function()
          require("dap.ui.widgets").hover()
        end,
        desc = "Widgets",
      },
    },

    config = function()
      -- load mason-nvim-dap here, after all adapters have been setup
      if LazyVim.has("mason-nvim-dap.nvim") then
        require("mason-nvim-dap").setup(LazyVim.opts("mason-nvim-dap.nvim"))
      end

      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      for name, sign in pairs(LazyVim.config.icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end

      -- setup dap config by VsCode launch.json file
      local vscode = require("dap.ext.vscode")
      local json = require("plenary.json")
      vscode.json_decode = function(str)
        return vim.json.decode(json.json_strip_comments(str))
      end
    end,
  },

  -- for typescript, LazyVim also includes extra specs to properly setup lspconfig,
  -- treesitter, mason and typescript.nvim. So instead of the above, you can use:
  { import = "lazyvim.plugins.extras.lang.typescript" },

  -- add more treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
        "ninja",
        "rst",
      },
    },
  },

  -- since `vim.tbl_deep_extend`, can only merge tables and not lists, the code above
  -- would overwrite `ensure_installed` with the new value.
  -- If you'd rather extend the default config, use the code below instead:
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
        "tsx",
        "typescript",
      })
    end,
  },

  -- the opts function can also be used to change the default opts:
  -- {
  --   "nvim-lualine/lualine.nvim",
  --   event = "VeryLazy",
  --   opts = function(_, opts)
  --     table.insert(opts.sections.lualine_x, "😄")
  --   end,
  -- },

  -- or you can return new options to override all the defaults
  -- {
  --   "nvim-lualine/lualine.nvim",
  --   opts = function()
  --     return {
  --       --[[add your custom lualine config here]]
  --     }
  --   end,
  -- },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        icons_enabled = true,
        -- theme = "material-stealth",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        always_show_tabline = true,
        globalstatus = true,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
          refresh_time = 16,
          events = {
            "WinEnter",
            "BufEnter",
            "BufWritePost",
            "SessionLoadPost",
            "FileChangedShellPost",
            "VimResized",
            "Filetype",
            "CursorMoved",
            "CursorMovedI",
            "ModeChanged",
          },
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    },
  },
  -- use mini.starter instead of alpha
  -- { import = "lazyvim.plugins.extras.ui.mini-starter" },

  -- add jsonls and schemastore packages, and setup treesitter for json, json5 and jsonc
  { import = "lazyvim.plugins.extras.lang.json" },

  -- add any tools you want to have installed below
}
