-- init.lua — Neovim 0.12+ starter, built-in vim.pack (no lazy.nvim, no
-- other plugin manager). Vanilla-first, leader-prefixed custom maps only —
-- same philosophy as your existing WSL config. Copy that one over this
-- once you've reconciled the two; this is just a working starting point.

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- === Options ===
local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.ignorecase = true
opt.smartcase = true
opt.splitright = true
opt.splitbelow = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.undofile = true
opt.scrolloff = 8
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.wrap = false

-- === Plugins via the built-in vim.pack (Neovim 0.12+) ===
-- No lockfile/lazy-loading framework — vim.pack just clones/updates git repos
-- into stdpath('data')/site/pack. Update everything with:
--   :lua vim.pack.update()
vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "master" },
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/ibhagwan/fzf-lua",      -- you already live in fzf everywhere else
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/echasnovski/mini.nvim", -- statusline/surround, one dep instead of five
})

require("mini.statusline").setup()
require("mini.surround").setup()
require("gitsigns").setup()

require("nvim-treesitter.configs").setup({
  ensure_installed = { "lua", "python", "bash", "yaml", "toml", "markdown", "json" },
  highlight = { enable = true },
})

-- === LSP ===
-- Add server names here once you've installed the actual language servers
-- (via your package manager of choice — mason.nvim is optional, not included
-- here to keep this vanilla-first).
vim.lsp.enable({ "lua_ls" })

-- === Keymaps (leader-prefixed, vanilla-first) ===
local map = vim.keymap.set
local fzf = require("fzf-lua")

map("n", "<leader>ff", fzf.files,      { desc = "Find files" })
map("n", "<leader>fg", fzf.live_grep,  { desc = "Live grep" })
map("n", "<leader>fb", fzf.buffers,    { desc = "Buffers" })
map("n", "<leader>e",  ":Ex<CR>",      { desc = "Netrw file explorer" })
map("n", "<leader>w",  ":w<CR>",       { desc = "Save" })
map("n", "<leader>q",  ":q<CR>",       { desc = "Quit" })
map("n", "<leader>gg", ":LazyGit<CR>", { desc = "Lazygit (if invoked from inside nvim's terminal)" })
