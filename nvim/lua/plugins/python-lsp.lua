return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Load your custom diagnostics configuration
      vim.defer_fn(function()
        require("config.diagnostics")
      end, 100)

      -- Then modify the servers table
      opts.autoformat = true
      opts.servers = vim.tbl_deep_extend("force", opts.servers or {}, {
        pyright = {
          enabled = true,
          settings = {
            pyright = {
              disableOrganizeImports = true,
              autoImportCompletion = true,
            },
            python = {
              analysis = {
                ignore = { "*" },
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                autoImportCompletions = true,
                diagnosticMode = "workspace",
              },
            },
          },
          root_dir = function(fname)
            local util = require("lspconfig.util")
            return util.root_pattern(
              "pyrightconfig.json",
              "pyproject.toml",
              "setup.py",
              "setup.cfg",
              "requirements.txt",
              "Pipfile",
              ".git"
            )(fname) or util.path.dirname(fname)
          end,
          before_init = function(_, config)
            local util = require("lspconfig.util")
            local path = util.path
            local function find_venv(startpath)
              local venv_paths = {
                path.join(startpath, ".venv", "bin", "python"),
                path.join(startpath, "venv", "bin", "python"),
                path.join(startpath, ".virtualenv", "bin", "python"),
                path.join(startpath, "env", "bin", "python"),
              }
              for _, venv_path in ipairs(venv_paths) do
                if vim.fn.executable(venv_path) == 1 then
                  return path.dirname(path.dirname(venv_path))
                end
              end
              return nil
            end
            local root = config.root_dir
            if root then
              local venv = find_venv(root)
              if venv then
                config.settings.python.pythonPath = path.join(venv, "bin", "python")
                config.settings.python.venvPath = path.dirname(venv)
                config.settings.python.venv = vim.fs.basename(venv)
              end
            end
          end,
        },
        ruff = false,
      })

      return opts
    end,
  },
  -- Mason and conform plugins unchanged
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "pyright",
        -- "ruff",
        "debugpy",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        python = { "ruff_format" },
      },
    },
  },
}
