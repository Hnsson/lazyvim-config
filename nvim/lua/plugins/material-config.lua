return {
  -- {
  --   "marko-cerovac/material.nvim", -- this points to the GitHub repo you gave
  --   priority = 1000,
  --   lazy = false,
  --   config = function()
  --     vim.g.material_style = "darker"
  --
  --     require("material").setup({
  --       plugins = {
  --         "gitsigns",
  --         "nvim-cmp",
  --         "nvim-tree",
  --         "telescope",
  --         "trouble",
  --         "which-key",
  --       },
  --     })
  --
  --     vim.cmd([[colorscheme material]])
  --   end,
  -- },
  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {
  --     style = "moon", -- set the style here
  --   },
  --   config = function(_, opts)
  --     require("tokyonight").setup(opts)
  --     vim.cmd("colorscheme tokyonight")
  --   end,
  -- },
  --   {
  --     "projekt0n/github-nvim-theme",
  --     name = "github-theme",
  --     lazy = false, -- make sure we load this during startup if it is your main colorscheme
  --     priority = 1000, -- make sure to load this before all the other start plugins
  --     config = function()
  --       require("github-theme").setup({
  --         -- ...
  --       })
  --
  --       vim.cmd("colorscheme github_dark_default")
  --     end,
  --   },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false, -- load immediately
    priority = 1000, -- high priority so it loads early
    opts = {
      flavour = "mocha", -- latte, frappe, macchiato, mocha
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd("colorscheme catppuccin")
    end,
  },
}
