-- Structure somewhat copied from wbthomason.

local fn = vim.fn

local map = vim.api.nvim_set_keymap

vim.wo.number = true
vim.wo.relativenumber = true

vim.bo.smartindent = true

vim.o.expandtab = true -- although :help says its local to buffer wtf
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2

vim.api.nvim_exec([[
   autocmd Filetype java setlocal tabstop=4 shiftwidth=4 softtabstop=4
]], false)

vim.o.scrolloff = 5
vim.o.sidescrolloff = 5
vim.o.sidescroll = 1

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.wo.list = true
-- vim.o.listchars = vim.o.listchars .. ',space:·'
vim.o.listchars = vim.o.listchars .. ',eol:↲'

--Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

vim.bo.swapfile = false
vim.o.backup = false
vim.o.writebackup = false

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

map('n', '<leader><esc>', ':nohlsearch<cr>', { noremap = true })
map('n', '<leader>w', ':w<cr>', { noremap = true })
map('n', '<leader>q', ':q<cr>', { noremap = true })
map('n', '<leader>1', ':Ex<cr>', { noremap = true })
map('n', '<leader>2', ':e .<cr>', { noremap = true })

map('n', '<leader>t', ':tabnew<cr>', { noremap = true })

map('n', 'Y', 'yg_', { noremap = true })

map('n', 'j', "(v:count == 0 ? 'gj' : 'j')", { noremap = true, expr = true, silent = true })
map('n', 'k', "(v:count == 0 ? 'gk' : 'k')", { noremap = true, expr = true, silent = true })
map('v', '<', '<gv', { noremap = true })
map('v', '>', '>gv', { noremap = true })

map('n', '<C-h>', '<C-w>h', { noremap = true })
map('n', '<C-j>', '<C-w>j', { noremap = true })
map('n', '<C-k>', '<C-w>k', { noremap = true })
map('n', '<C-l>', '<C-w>l', { noremap = true })

require('plugins')
