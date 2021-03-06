local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
   execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
   execute 'packadd packer.nvim'
end

-- Only required if you have packer in your `opt` pack
vim.cmd [[packadd packer.nvim]]

local use_new_stack = false
local use_telescope = true
local use_treesitter = true

-- local use = require('packer').use -- not really needed but why is the linter complaining
return require('packer').startup(function()
   -- Packer can manage itself as an optional plugin
   use { 'wbthomason/packer.nvim', opt = true }

   -- syntax highlighting
   use {
      'sheerun/vim-polyglot',
      disable = false
   }

   use { 'iamcco/markdown-preview.nvim',
        run = 'cd app && yarn install',
        -- cmd = 'MarkdownPreview'
   }

   use { 'tpope/vim-surround', event = 'VimEnter *' }
   use { 'andymass/vim-matchup', event = 'VimEnter *' }

   -- vc
   use 'tpope/vim-fugitive'
   use { 'kdheepak/lazygit.nvim', disable = true } -- try it sometimes... looks cool
   use {
      'lewis6991/gitsigns.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
      config = function() require('config.gitsigns') end
   }
   use {
      'lambdalisue/suda.vim',
      config = function() end
   }
   use {
      'christoomey/vim-tmux-navigator',
      config = function() require('config.vim-tmux') end
   }

   use { 'preservim/nerdcommenter', config = function () require('config.nerdcommenter') end }
   use {
      'mhartington/oceanic-next',
      config = function ()
         vim.o.termguicolors = true
         vim.g.oceanic_next_terminal_bold = 1
         vim.g.oceanic_next_terminal_italic = 1
         vim.cmd[[colorscheme OceanicNext]]
      end
   }
   use 'kyazdani42/nvim-web-devicons'
   use 'vim-airline/vim-airline'
   use {
      'lukas-reineke/indent-blankline.nvim', branch = "lua",
      disable = true,
      config = function() end
   }
   use { 'glepnir/indent-guides.nvim', disable = true } -- indent-guides
   use { 'glepnir/galaxyline.nvim', disable = true } -- looks very satisfactory
   use { 'nvim-lua/lsp-status.nvim', disable = true } -- build it myself?
   use { 'romgrk/barbar.nvim', disable = true } -- looks cool

   -- formatters
   use { 'sbdchd/neoformat', config = function () require('config.neoformat') end }
   use { 'mhartington/formatter.nvim', disable = true }

   use { 'direnv/direnv.vim' }
   use { 'junegunn/fzf', disable = use_telescope }
   use { 'junegunn/fzf.vim', disable = use_telescope, config = function() require('config.fzf') end }
   use {
      'nvim-telescope/telescope.nvim',
      disable = not use_telescope,
      requires = {
         { 'nvim-lua/popup.nvim' },
         { 'nvim-lua/plenary.nvim' }
      },
      config = function() require('config.telescope') end
   }

   -- snippet support
   use { 'sirver/UltiSnips', requires = { 'honza/vim-snippets' } }

   -- lisp balls deep in
   use {
      'Olical/conjure',
      requires = {
         { 'clojure-vim/vim-jack-in',
           requires = {
              { 'tpope/vim-dispatch' },
              { 'radenling/vim-dispatch-neovim' }
           }
         }
      },
      config = function() require('config.conjure') end
   }

   -- treesitter
   use {
      'nvim-treesitter/nvim-treesitter',
      disable = not use_treesitter,
      run = ':TSUpdate',
      requires = {
         -- 'nvim-treesitter/nvim-treesitter-refactor',
         -- 'nvim-treesitter/nvim-treesitter-textobjects'
         { 'nvim-treesitter/playground' }
      },
      config = function() require('config.treesitter') end
   }

   use { 'mfussenegger/nvim-lint', disable = true } -- idea is great

   -- completion options
   use {
      'neoclide/coc.nvim',
      disable = use_new_stack,
      config = function() require('config.coc') end
   }
   use {
      'hrsh7th/nvim-compe',
      disable = not use_new_stack,
      config = function() require('config.nvim-compe') end
   }
   use {
      'neovim/nvim-lspconfig',
      disable = not use_new_stack,
      config = function() require('config.nvim-lspconfig') end
   }
end)
