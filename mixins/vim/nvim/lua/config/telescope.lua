vim.api.nvim_exec([[
   " Using lua functions
   nnoremap <leader>e <cmd>lua require('telescope.builtin').find_files()<cr>
   nnoremap <leader>g <cmd>lua require('telescope.builtin').live_grep()<cr>
   nnoremap <leader>b <cmd>lua require('telescope.builtin').buffers()<cr>
   nnoremap <leader>h <cmd>lua require('telescope.builtin').help_tags()<cr>
   nnoremap <leader>tg <cmd>lua require('telescope.builtin').git_files()<cr>
   nnoremap <leader>tb <cmd>lua require('telescope.builtin').file_browser()<cr>
   nnoremap <leader>ts <cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>
   nnoremap <leader>tw <cmd>lua require('telescope.builtin').lsp_workspace_symbols()<cr>
]], false)
