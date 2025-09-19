vim.opt_local.spelllang = 'en_us'
vim.opt_local.spell = true
vim.opt_local.cindent = false
vim.opt_local.textwidth = 80

local map = vim.keymap.set
local opts = {silent = true, noremap = true, buffer = true}

map('i', '_', '_{}<left>', opts)
map('i', '^', '^{}<left>', opts)
map('i', '$', '\\(\\)<left><left>', opts)
map('i', '\"', '``\'\'<left><left>', opts)
map('i', "<C-'>", '\\', opts)

-- map('n', '<localleader>t', ':call vimtex#fzf#run()<cr>', opts)
