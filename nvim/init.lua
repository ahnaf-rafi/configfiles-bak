--------------------------------------------------------------------------------
--- Settings
--------------------------------------------------------------------------------
local opt = vim.opt -- for conciseness

-- Line numbers, make them relative.
opt.number = true
opt.relativenumber = true

-- Adjust splitting behavior
opt.splitbelow = true
opt.splitright = true

-- Set highlight on search
opt.hlsearch = false

-- Case-insensitive searching UNLESS \C or capital in search
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Tabs and indentation
opt.cindent = false
opt.autoindent = true
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true

-- Enable mouse mode
opt.mouse = 'a'

-- Sync clipboard between OS and Neovim. See `:help 'clipboard'`
opt.clipboard = 'unnamedplus'

-- Save undo history
opt.undofile = true

-- Keep signcolumn on by default
opt.signcolumn = 'yes'

-- Enable break indent
opt.breakindent = true

-- Break lines at
opt.linebreak = true

-- Column indicators
opt.colorcolumn = '81,101,121'

-- Highlight current line
opt.cursorline = true

-- Disable vim folds
opt.foldenable = false

-- Some globals
vim.g.python3_host_prog = '~/miniforge3/bin/python3'
vim.g.tex_flavor = 'latex'
vim.g.tex_comment_nospell = 1
-- vim.g.tex_nospell = 1

vim.cmd('set iskeyword-=_')

-- Some settings to reorganize.
--[[
opt.updatetime = 1000
opt.shortmess = opt.shortmess .. 'FcI'
--]]

--------------------------------------------------------------------------------
--- Basic keymaps
--------------------------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " m"

local keyopts = {silent = true, noremap = true}
local keymap = vim.keymap.set

keymap({"n", "v"}, "j", "gj", keyopts)
keymap({"n", "v"}, "k", "gk", keyopts)
keymap("v", "<", "<gv", keyopts) -- Better indent in visual
keymap("v", ">", ">gv", keyopts) -- Better dedent in visual
keymap({"i", "v"}, "fd", "<esc>", keyopts) -- fd = esc in insert
keymap("t", "<c-f><c-d>", "<c-\\><c-n>", keyopts) -- <c-f><c-d> = esc in term
keymap("i", "<m-b>", "<c-left>", keyopts)
keymap("i", "<m-f>", "<c-right>", keyopts)
keymap("i", "<c-b>", "<left>", keyopts)
keymap("i", "<c-f>", "<right>", keyopts)
keymap({"n", "v"}, "<leader>fs", ":update<cr>", keyopts)

keyopts.desc = "+window"
keymap("n", "<leader>w", "<c-w>", keyopts)

keyopts.desc = "delete"
keymap('n', '<c-w>x', ':<c-u>bdel<cr>', keyopts)
keymap('n', '<leader>wx', ':<c-u>bdel<cr>', keyopts)

keyopts.desc = 'Copy Absolute Path'
keymap('n', '<leader>fyy', ':<c-u>let @+=expand("%:p")<cr>', keyopts)

keyopts.desc = 'Copy Directory Path'
keymap('n', '<leader>fyd', ':<c-u>let @+=expand("%:p:h")<cr>', keyopts)

keyopts.desc = 'Copy File Name'
keymap('n', '<leader>fyn', ':<c-u>let @+=expand("%:t")<cr>', keyopts)

keyopts.desc = 'Copy Relative File Name'
keymap('n', '<leader>fyr', ':<c-u>let @+=expand("%")<cr>', keyopts)

keyopts.desc = 'Delete Buffer'
keymap('n', '<leader>bd', ':<c-u>bprev<cr>:bdel #<cr>', keyopts)

keyopts.desc = 'Previous Buffer'
keymap('n', '<leader>bp', ':<c-u>bprev<cr>', keyopts)
keymap('n', '<leader>b[', ':<c-u>bprev<cr>', keyopts)

keyopts.desc = 'Next Buffer'
keymap('n', '<leader>bn', ':<c-u>bnext<cr>', keyopts)
keymap('n', '<leader>b]', ':<c-u>bnext<cr>', keyopts)

keyopts.desc = 'Clear search'
keymap('n', '<leader>sc', ':nohl<cr>', keyopts)

keyopts.desc = 'Terminal Other Window'
keymap('n', '<leader>at', ':<c-u>vsp | term<cr>', keyopts)

keyopts.desc = 'Terminal Current Window'
keymap('n', '<leader>aT', ':<c-u>term<cr>', keyopts)

--------------------------------------------------------------------------------
--- Packages
--------------------------------------------------------------------------------
vim.pack.add({

  -- Colorscheme
  {src = "https://github.com/ellisonleao/gruvbox.nvim"},

  -- Editor
  -- {src = "https://github.com/lewis6991/spaceless.nvim"},

  -- File browsing
  {src = "https://github.com/stevearc/oil.nvim"},

  -- Language Server Protocol (LSP)
  {src = "https://github.com/neovim/nvim-lspconfig"},

  -- Languages
  {src = "https://github.com/lervag/vimtex"},
})

--------------------------------------------------------------------------------
--- Colorscheme
--------------------------------------------------------------------------------

opt.background = "dark"
vim.cmd("colorscheme gruvbox")

--------------------------------------------------------------------------------
--- Oil configuration
--------------------------------------------------------------------------------
require("oil").setup()

--------------------------------------------------------------------------------
--- LSP configuration
--------------------------------------------------------------------------------
vim.lsp.enable({"lua_ls", "texlab"})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      }
    }
  }
})

--------------------------------------------------------------------------------
--- Handling double spaces
--------------------------------------------------------------------------------
-- Replace 2+ spaces with a single space if they appear after the first
-- non-space character in the line (to preserve indentation) when leaving
-- insert mode, without creating a new undo entry.

-- Main action
local function squeeze_double_spaces_current_line(bufnr)
  -- Save/restore view so the cursor and screen don't jump.
  local view = vim.fn.winsaveview()

  -- Temporarily disable undo recording.
  local old_undolevels = vim.bo[bufnr].undolevels
  vim.bo[bufnr].undolevels = -1

  -- Substitution pattern.
  vim.cmd([[silent! keepjumps keeppatterns %s/\S\zs\s\{2,}/ /ge]])

  -- Restore undo setting and view.
  vim.bo[bufnr].undolevels = old_undolevels
  vim.fn.winrestview(view)
end

-- Set up the autocmd.
local squeeze_doublespaces_aug = vim.api.nvim_create_augroup(
  "SqueezeDoubleSpacesOnInsertLeave", { clear = true }
)
vim.api.nvim_create_autocmd("InsertLeave", {
  group = squeeze_doublespaces_aug,
  callback = function(args)
    squeeze_double_spaces_current_line(args.buf)
  end,
})
