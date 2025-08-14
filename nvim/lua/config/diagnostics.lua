vim.diagnostic.config({
  virtual_text = {
    prefix = function(diagnostic)
      local icons = {
        [vim.diagnostic.severity.ERROR] = "  ",
        [vim.diagnostic.severity.WARN] = "  ",
        [vim.diagnostic.severity.INFO] = "  ",
        [vim.diagnostic.severity.HINT] = " 󰌵 ",
      }
      return icons[diagnostic.severity] or ""
    end,
    spacing = 4,
  },
  signs = true,
  float = { source = "always", border = "rounded", header = "", prefix = "" },
  severity_sort = true,
})

-- Catppuccin diagnostic colors
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { bg = "#472831", fg = "#F38BA8" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { bg = "#4f4837", fg = "#FAE3B0" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { bg = "#395d63", fg = "#89DCEB" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { bg = "#4b6648", fg = "#A6E3A1" })
