-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.loaded_netrwPlugin = 0

local opts = vim.opt

opts.shiftwidth = 4 -- Size of an indent
opts.tabstop = 4 -- Number of spaces tabs count for
-- opts.softtabstop = 0 -- Number of columns for a TAB
opts.wrap = true -- Disable line wrap
opts.pumheight = 5 -- Maximum number of entries in a popup
opts.listchars = "tab:␉·" -- Invisible character
opts.cursorline = true -- Enable highlighting of the current line
opts.scrolloff = 4 -- Keep 4 lines visible above/below cursor
-- opts.scrolljump = 1 -- Scroll one line at a time

-- Disable unnecessary features
opts.updatetime = 300 -- Faster completion
opts.swapfile = false -- Reduces disk I/O
opts.writebackup = false
opts.clipboard = "" -- Disable system clipboard if it causes lag
opts.showmode = false -- LazyVim already handles this

-- LSP Server to use for PHP.
-- Set to "intelephense" to use intelephense instead of phpactor.
vim.g.lazyvim_php_lsp = "intelephense"
