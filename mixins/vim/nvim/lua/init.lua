-- Shorthands
local execute = vim.api.nvim_command
local fn = vim.fn

local map = vim.api.nvim_set_keymap

vim.wo.number = true
vim.wo.relativenumber = true

vim.bo.smartindent = true

vim.bo.expandtab = true
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
vim.o.listchars = vim.o.listchars .. ',space:·'

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

local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
   execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
   execute 'packadd packer.nvim'
end

-- Only required if you have packer in your `opt` pack
vim.cmd [[packadd packer.nvim]]

-- local use = require('packer').use -- not really needed but why is the linter complaining
return require('packer').startup(function()
   -- Packer can manage itself as an optional plugin
   use { 'wbthomason/packer.nvim', opt = true }
   use { 'sheerun/vim-polyglot',}
   use { 'tpope/vim-surround', event = 'VimEnter *' } -- Load on an autocommand event
   use { 'andymass/vim-matchup', event = 'VimEnter *' }
   use {'tpope/vim-fugitive'}
   -- use {'kdheepak/lazygit.nvim'} -- try it sometimes... looks cool
   use { 'vim-airline/vim-airline' }

   use 'preservim/nerdcommenter'
   use {
      'mhartington/oceanic-next',
      config = function ()
         vim.o.termguicolors = true
         vim.g.oceanic_next_terminal_bold = 1
         vim.g.oceanic_next_terminal_italic = 1
         vim.cmd[[colorscheme OceanicNext]]
      end
   }


   use { 'kyazdani42/nvim-web-devicons' }
   -- use { 'glepnir/indent-guides.nvim' } -- indent-guides
   -- use { 'glepnir/galaxyline.nvim' } -- looks very satisfactory
   -- use { 'nvim-lua/lsp-status.nvim', } -- build it myself?
   -- use { 'romgrk/barbar.nvim', } -- looks cool

   use { 'sbdchd/neoformat',
         config = function()
            vim.api.nvim_set_keymap('', '<leader>;', ':Neoformat<cr>', { noremap = true })
         end
   }
   use {
      'lewis6991/gitsigns.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
      config = function()
         require('gitsigns').setup()
      end
   }
   use { 'direnv/direnv.vim' }
   use { 'junegunn/fzf' }
   use {
      'junegunn/fzf.vim',
      config = function()
         local map = vim.api.nvim_set_keymap
         map('n', '<leader>e', ':Files<cr>', { noremap = true })
         map('n', '<leader>r', ':Rg<cr>', { noremap = true })
         map('n', '<leader>g', ':GFiles<cr>', { noremap = true })
         map('n', '<leader>b', ':Buffers<cr>', { noremap = true })
      end
   }
   use {
      'nvim-telescope/telescope.nvim',
      requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
   }
   use {'sirver/UltiSnips'}
   use {'honza/vim-snippets'}
   use {'Olical/conjure'}
   -- clojure stack
   use {'clojure-vim/vim-jack-in',
        requires = {{'tpope/vim-dispatch'}, {'radenling/vim-dispatch-neovim'}}}

   -- require('built-in-lsp-combo')
   require('coc')
   require('treesitter')
end)
