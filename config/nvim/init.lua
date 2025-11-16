--------------------------------------------------------------------------------
--- Settings
--------------------------------------------------------------------------------
-- For conciseness
local opt = vim.opt
local g = vim.g

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

-- Window borders
opt.winborder = "rounded"

-- Completion options
vim.cmd[[set completeopt+=menuone,noselect,popup]]

-- Some globals
g.python3_host_prog = '~/miniforge3/bin/python3'
g.tex_flavor = 'latex'
g.tex_comment_nospell = 1
-- g.tex_nospell = 1

vim.cmd('set iskeyword-=_')

-- Some settings to reorganize.
--[[
opt.updatetime = 1000
opt.shortmess = opt.shortmess .. 'FcI'
--]]

--------------------------------------------------------------------------------
--- Basic keymaps
--------------------------------------------------------------------------------
g.mapleader = " "
g.maplocalleader = " m"

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
  {src = "https://github.com/kylechui/nvim-surround"},

  -- File browsing
  {src = "https://github.com/stevearc/oil.nvim"},

  -- Fuzzy finding
  {src = "https://github.com/ibhagwan/fzf-lua"},

  -- Language Server Protocol (LSP)
  {src = "https://github.com/neovim/nvim-lspconfig"},

  -- Treesitter
  {src = "https://github.com/nvim-treesitter/nvim-treesitter"},

  -- Snippets
  {src = "https://github.com/L3MON4D3/LuaSnip"},

  -- Languages
  {src = "https://github.com/lervag/vimtex"},
  {src = "https://github.com/chomosuke/typst-preview.nvim"},
  {src = "https://github.com/R-nvim/R.nvim"}
})

--------------------------------------------------------------------------------
--- Colorscheme
--------------------------------------------------------------------------------
opt.background = "dark"
vim.cmd("colorscheme gruvbox")

--------------------------------------------------------------------------------
--- Editing Plugins
--------------------------------------------------------------------------------
require("nvim-surround").setup({})

--------------------------------------------------------------------------------
--- Oil configuration
--------------------------------------------------------------------------------
require("oil").setup()

--------------------------------------------------------------------------------
--- fzf-lua
--------------------------------------------------------------------------------
require('fzf-lua').setup()
keymap({"n", "v"}, "<leader>ff",
  FzfLua.files,
  keyopts)
keymap({"n", "v"}, "<leader>bb", ":FzfLua buffers<cr>", keyopts)

--------------------------------------------------------------------------------
--- LSP configuration
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local keyopts = { noremap = true, silent = true, buffer = ev.buf}
    local map = vim.keymap.set

    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, {
        autotrigger = true
      })
    end

    ------------------
    -- Set keybinds --
    ------------------

    -- Show definition, references
    -- keyopts.desc = "Show LSP references"
    -- map("n", "gr", "<cmd>Telescope lsp_references<CR>", keyopts)

    -- Go to declaration
    keyopts.desc = "Go to declaration"
    map("n", "gD", vim.lsp.buf.declaration, keyopts)

    -- Show lsp definitions
    -- keyopts.desc = "Show LSP definitions"
    -- map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", keyopts)

    -- Show lsp implementations
    -- keyopts.desc = "Show LSP implementations"
    -- map("n", "gi", "<cmd>Telescope lsp_implementations<CR>", keyopts)

    -- Show lsp type definitions
    -- keyopts.desc = "Show LSP type definitions"
    -- map("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", keyopts)

    -- See available code actions, in visual mode will apply to selection
    keyopts.desc = "See available code actions"
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, keyopts)

    -- Smart rename
    keyopts.desc = "Smart rename"
    map("n", "gR", vim.lsp.buf.rename, keyopts)
    -- map("n", "<leader>cr", vim.lsp.buf.rename, keyopts)

    -- Show diagnostics for file
    -- keyopts.desc = "Show buffer diagnostics"
    -- map("n", "<leader>cD", "<cmd>Telescope diagnostics bufnr=0<CR>", keyopts)

    -- Show diagnostics for line
    keyopts.desc = "Show line diagnostics"
    map("n", "<leader>cd", vim.diagnostic.open_float, keyopts)

    -- Jump to previous diagnostic in buffer
    keyopts.desc = "Go to previous diagnostic"
    map(
      "n", "[d",
      function ()
        vim.diagnostic.jump({count=-1, float=true})
      end,
      keyopts
    )

    -- Jump to next diagnostic in buffer
    keyopts.desc = "Go to next diagnostic"
    map(
      "n", "]d",
      function ()
        vim.diagnostic.jump({count=1, float=true})
      end,
      keyopts
    )

    -- Show documentation for what is under cursor
    keyopts.desc = "Show documentation for what is under cursor"
    map("n", "K", vim.lsp.buf.hover, keyopts)

    -- Mapping to restart lsp if necessary
    keyopts.desc = "Restart LSP"
    map("n", "<leader>clr", ":LspRestart<CR>", keyopts)
  end
})

vim.lsp.enable({"lua_ls", "texlab", "tinymist", "julials"})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      }
    }
  }
})

vim.lsp.config("tinymist", {
  cmd = { "tinymist" },
  filetypes = { "typst" },
  settings = {
    formatterMode = "typstyle",
    exportPdf = "onType",
    semanticTokens = "disable"
  },
  on_attach = function(client, bufnr)
    vim.keymap.set("n", "<leader>tp", function()
      client:exec_cmd({
        title = "pin",
        command = "tinymist.pinMain",
        arguments = { vim.api.nvim_buf_get_name(0) },
      }, { bufnr = bufnr })
    end, { desc = "[T]inymist [P]in", noremap = true })

    vim.keymap.set("n", "<leader>tu", function()
      client:exec_cmd({
        title = "unpin",
        command = "tinymist.pinMain",
        arguments = { vim.v.null },
      }, { bufnr = bufnr })
    end, { desc = "[T]inymist [U]npin", noremap = true })
  end,
})

--------------------------------------------------------------------------------
--- Treesitter
--------------------------------------------------------------------------------
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    -- bash,
    "bibtex",
    "git_config",
    "gitcommit",
    "gitignore",
    "julia",
    -- "latex",
    "lua",
    "markdown",
    "markdown_inline",
    "nix",
    "r",
    "rnoweb",
    "typst",
    "vim",
    "vimdoc",
    "yaml"
  },
  sync_install = true,
  highlight = {
    enable = true,
    -- disable = { "julia" },
    -- disable = { "latex" },
  },
  indent = { enable = true },
  ignore_install = {},
  auto_install = false,
  modules = {},
})

--------------------------------------------------------------------------------
--- Snippets
--------------------------------------------------------------------------------
require("luasnip").setup({
  enable_autosnippets = true,
  store_selection_keys = "<Tab>",
})
require("luasnip.loaders.from_lua").lazy_load({
  paths = "~/.config/nvim/LuaSnip/"
})

vim.cmd[[
" press <Tab> to expand or jump in a snippet.
" These can also be mapped separately via <Plug>luasnip-expand-snippet and
" <Plug>luasnip-jump-next.
imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'
snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>

" Use Shift-Tab to jump backwards through snippets (that's what the -1 is for)
inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>
snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>

" For changing choices in choiceNodes (not strictly necessary for a basic setup).
imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'

" Use Tab to expand and jump through snippets
"imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'
"smap <silent><expr> <Tab> luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : '<Tab>'

"" Use Shift-Tab to jump backwards through snippets
"imap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
"smap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
]]

--------------------------------------------------------------------------------
--- Typst
--------------------------------------------------------------------------------

vim.api.nvim_create_user_command("OpenPdf", function()
  local filepath = vim.api.nvim_buf_get_name(0)
  if filepath:match("%.typ$") then
    local pdf_path = filepath:gsub("%.typ$", ".pdf")
    vim.system(
      --- { "open", pdf_path }
      { "zathura", pdf_path }
    )
  end
end, {})

--------------------------------------------------------------------------------
--- Vimtex
--------------------------------------------------------------------------------
-- disable `K` as it conflicts with LSP hover
g.vimtex_mappings_disable = { ["n"] = { "K" } }
g.vimtex_view_method = 'sioyek'
-- g.vimtex_view_method = 'skim'
-- g.vimtex_callback_progpath = '/opt/homebrew/bin/nvim'
-- g.vimtex_callback_progpath = exepath(v:progname)
g.vimtex_fold_enabled = 0
g.vimtex_indent_enabled = 1
g.vimtex_indent_delims = {
  open = {},
  close = {},
  close_indented = 0,
  include_modified_math = 0
}
g.vimtex_syntax_enabled = 1
g.vimtex_syntax_conceal_disable = 1
g.tex_indent_items = 0
g.tex_no_error = 1
g.vimtex_mappings_prefix = '<localleader>'

g.vimtex_indent_ignored_envs = {
  'document',
  "frame",
  "theorem",
  "thm",
  "corollary",
  "cor",
  "lemma",
  "lem",
  "definition",
  "def",
  "assumption",
  "asm",
  "remark",
  "rem",
  "example",
  "eg",
  "notation",
  "note",
  "problem",
  "solution",
  "proof"
}

g.vimtex_toc_config = {
  fold_enable = 0,
  fold_level_start = -1,
  hide_line_numbers = 1,
  hotkeys = "abcdeilmnopuvxyz",
  hotkeys_enabled = 0,
  hotkeys_leader = ";",
  indent_levels = 0,
  layer_keys = {
    content = "C",
    include = "I",
    label = "L",
    todo = "T"
  },
  layer_status = {
    content = 1,
    include = 1,
    label = 1,
    todo = 1
  },
  mode = 1,
  name = "Table of contents (VimTeX)",
  refresh_always = 1,
  resize = 0,
  show_help = 1,
  show_numbers = 1,
  -- split_pos = "vert leftabove",
  split_pos = "leftabove",
  split_width = 50,
  tocdepth = 3,
  todo_sorted = 1
}

--------------------------------------------------------------------------------
--- R.nvim
--------------------------------------------------------------------------------
-- Create a table with the options to be passed to setup()
---@type RConfigUserOpts
local opts = {
  -- hook = {
  -- on_filetype = function()
  -- vim.api.nvim_buf_set_keymap(0, "n", "<Enter>", "<Plug>RDSendLine", {})
  -- vim.api.nvim_buf_set_keymap(0, "v", "<Enter>", "<Plug>RSendSelection", {})
  -- end
  -- },
  R_args = {"--quiet", "--no-save"},
  -- min_editor_width = 72,
  -- rconsole_width = 78,
  -- objbr_mappings = { -- Object browser keymap
  -- c = 'class', -- Call R functions
  -- ['<localleader>gg'] = 'head({object}, n = 15)', -- Use {object} notation to write arbitrary R code.
  -- v = function()
  -- -- Run lua functions
  -- require('r.browser').toggle_view()
  -- end
  -- },
  -- disable_cmds = {
  -- "RClearConsole",
  -- "RCustomStart",
  -- "RSPlot",
  -- "RSaveClose",
  -- },
}
-- Check if the environment variable "R_AUTO_START" exists.
-- If using fish shell, you could put in your config.fish:
-- alias r "R_AUTO_START=true nvim"
if vim.env.R_AUTO_START == "true" then
  opts.auto_start = "on startup"
  opts.objbr_auto_start = true
end
require("r").setup(opts)

--------------------------------------------------------------------------------
--- Handling double spaces
--------------------------------------------------------------------------------
-- Replace 2+ spaces with a single space if they appear after the first
-- non-space character in the line (to preserve indentation) when leaving
-- insert mode, without creating a new undo entry.

-- Main action
local function squeeze_double_spaces(bufnr)
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
    squeeze_double_spaces(args.buf)
  end,
})
