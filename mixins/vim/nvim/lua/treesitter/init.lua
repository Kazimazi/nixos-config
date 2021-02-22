local use = require('packer').use

use {
   'nvim-treesitter/nvim-treesitter',
   run = ':TSUpdate',
   config = function()
      vim.o.foldlevel = 99
      vim.o.foldmethod = 'expr'
      vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
      require'nvim-treesitter.configs'.setup {
         ensure_installed = 'all', -- one of 'all', 'maintained' (parsers with maintainers), or a list of languages
         highlight = {
            enable = true,
            disable = {'clojure',},  -- list of language that will be disabled
            --custom_captures = {
            --  -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
            --  ['foo.bar'] = 'Identifier',
            --},
         },
         incremental_selection = {
            enable = true,
            keymaps = {
               init_selection = 'gnn',
               node_incremental = 'gni',
               scope_incremental = 'gsi',
               node_decremental = 'gnd',
            },
         },
         indent = {
            enable = false
         }
     }
   end
}
use { 'nvim-treesitter/playground' }
