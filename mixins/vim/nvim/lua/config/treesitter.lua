vim.o.foldlevel = 99
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'

require'nvim-treesitter.configs'.setup {
   ensure_installed = 'maintained',
   highlight = {
      enable = true,
      disable = {},
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
