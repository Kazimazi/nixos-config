local map = vim.api.nvim_set_keymap

map('n', '<leader>e', ':Files<cr>', { noremap = true })
map('n', '<leader>r', ':Rg<cr>', { noremap = true })
map('n', '<leader>g', ':GFiles<cr>', { noremap = true })
map('n', '<leader>b', ':Buffers<cr>', { noremap = true })
