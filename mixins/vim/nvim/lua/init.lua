-- Shorthands
local execute = vim.api.nvim_command
local fn = vim.fn

local map = vim.api.nvim_set_keymap

vim.wo.number = true
vim.wo.relativenumber = true

vim.o.smartindent = true

vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2

vim.o.scrolloff = 5
vim.o.sidescrolloff = 5
vim.o.sidescroll = 1

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

vim.api.nvim_exec([[
  set list
  set listchars+=space:·
]], false)

--Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

vim.o.swapfile = false
vim.o.backup = false
vim.o.writebackup = false

-- map the leader key
-- map('n', '<Space>', '', {})
vim.g.mapleader = ' '

map('n', '<leader><esc>', ':nohlsearch<cr>', { noremap = true })
map('n', '<leader>w', ':w<cr>', { noremap = true })
map('n', '<leader>q', ':q<cr>', { noremap = true })
map('n', '<leader>1', ':Ex<cr>', { noremap = true })
map('n', '<leader>2', ':e .<cr>', { noremap = true })

map('n', '<leader>t', ':tabnew<cr>', { noremap = true })

map('n', 'Y', 'y$', { noremap = true })

map('n', 'j', "(v:count == 0 ? 'gj' : 'j')", { noremap = true, expr = true, silent = true })
map('n', 'k', "(v:count == 0 ? 'gk' : 'k')", { noremap = true, expr = true, silent = true })
map('v', '<', '<gv', { noremap = true })
map('v', '>', '>gv', { noremap = true })

if fn.exists('g:vscode') == 0 then
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
      use '9mm/vim-closer'
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
      use { 'sbdchd/neoformat',
            config = function()
               vim.api.nvim_set_keymap('', '<leader>;', ':Neoformat<cr>', { noremap = true })
               -- Have Neoformat use &formatprg as a formatter
               vim.g.neoformat_try_formatprg = 1
               -- Enable alignment
               vim.g.neoformat_basic_format_align = 1
               -- Enable tab to spaces conversion
               vim.g.neoformat_basic_format_retab = 1
               -- Enable trimmming of trailing whitespace
               vim.g.neoformat_basic_format_trim = 1
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
            map('n', '<leader>a', ':Files<cr>', { noremap = true })
            map('n', '<leader>r', ':Rg<cr>', { noremap = true })
            map('n', '<leader>g', ':GFiles<cr>', { noremap = true })
            map('n', '<leader>b', ':Buffers<cr>', { noremap = true })
         end
      }
      use {
         'nvim-telescope/telescope.nvim',
         requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
      }
      require('built-in-lsp-combo')
      --require('coc')
   end)
end
