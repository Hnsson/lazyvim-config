-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
--
-- TOGGLE COMMENT
-- vim.keymap.set("n", "<C-_>", "gcc", { remap = true, desc = "Toggle comment line" })
-- vim.keymap.set("v", "<C-_>", "gc", { remap = true, desc = "Toggle comment selection" })
--
--
--
--
-- Function to send selected text to Amazon Q
local function send_to_amazon_q()
  -- Get visual selection
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.fn.getline(start_pos[2], end_pos[2])

  -- Join lines into a single string
  local text = table.concat(lines, "\n")

  -- Escape single quotes for safe shell single quoting
  local escaped_text = text:gsub("'", "'\"'\"'")

  -- Wrap escaped text in single quotes
  escaped_text = "'" .. escaped_text .. "'"

  -- Open terminal with Amazon Q and pass input after -- to avoid confusion with flags
  vim.cmd("split | terminal q chat -- " .. escaped_text)
end

-- Key mapping
--
-- GREP LSP SYMBOLS
vim.keymap.set("n", "<leader>sf", function()
  require("snacks.picker").lsp_symbols()
end, { desc = "LSP Symbols" })
--
--
-- WORK IN PROGRESS
-- vim.keymap.set("v", "<leader>cq", send_to_amazon_q, { desc = "Send selection to Amazon Q" })
vim.keymap.set("n", "<leader>cq", ":vsplit | terminal q<CR>", { desc = "Open Amazon Q to the side" })
-- GO HOME
vim.keymap.set("n", "<leader>fd", function()
  Snacks.dashboard()
end, { desc = "Open Dashboard" })
--
--
-- REMOVE INDENTATION
vim.keymap.set("v", "<Tab>", ">gv", { desc = "Indent selection" })
vim.keymap.set("v", "<S-Tab>", "<gv", { desc = "Unindent selection" })
--
--
-- COPY LINES
vim.keymap.set("n", "<A-Down>", "yyp", { desc = "Copy current line below" })
vim.keymap.set("n", "<A-Up>", "yyP", { desc = "Copy current line above" })
--
--
-- EXIT TERMINAL MODE
vim.keymap.set("t", "<C-Space>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
--
--
-- MOVING BUFFER
vim.keymap.set("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { desc = "Previous buffer" })
--
--
-- SPLITTING WINDOWS
vim.keymap.set("n", "<A-h>", ":split<CR>", { desc = "New horizontal split" })
vim.keymap.set("n", "<A-j>", ":vsplit<CR>", { desc = "New vertical split" })
vim.keymap.set("n", "<A-ESC>", ":close<CR>", { desc = "Close current window" })
--
--
-- MOVING BETWEEN WINDOWS
vim.keymap.set("n", "<C-Left>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-Right>", "<C-w>l", { desc = "Move to right window" })
vim.keymap.set("n", "<C-Down>", "<C-w>j", { desc = "Move to lower window" })
vim.keymap.set("n", "<C-Up>", "<C-w>k", { desc = "Move to upper window" })
--
--
-- RESIZING WINDOWS
vim.keymap.set("n", "<C-k>", "<cmd>resize +2<CR>", { desc = "Increase height" })
vim.keymap.set("n", "<C-j>", "<cmd>resize -2<CR>", { desc = "Decrease height" })
vim.keymap.set("n", "<C-h>", "<cmd>vertical resize -2<CR>", { desc = "Decrease width" })
vim.keymap.set("n", "<C-l>", "<cmd>vertical resize +2<CR>", { desc = "Increase width" })
