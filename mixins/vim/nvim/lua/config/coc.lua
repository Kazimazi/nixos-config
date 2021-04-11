vim.o.hidden = true
vim.o.cmdheight = 2

vim.wo.signcolumn = 'yes'

-- CocInstall these extensions
vim.g.coc_global_extensions = {'coc-pairs', 'coc-html', 'coc-css', 'coc-tsserver', 'coc-eslint', 'coc-java', 'coc-snippets', 'coc-conjure', 'coc-sh', 'coc-xml'}

vim.o.shortmess = vim.o.shortmess .. 'c'

-- <c-space> to trigger completion
vim.api.nvim_set_keymap('i', '<c-space>', 'coc#refresh()', { noremap = true, silent = true, expr = true })

-- Use `[d` and `]d` to navigate diagnostics
-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
vim.api.nvim_set_keymap('n', '[d', ":call CocActionAsync('diagnosticNext')<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', ']d', ":call CocActionAsync('diagnosticPrevious')<CR>", { noremap = true, silent = true })

-- GoTo code navigation.
vim.api.nvim_set_keymap('n', 'gd', ":call CocActionAsync('jumpDefinition')<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gy', ":call CocActionAsync('jumpTypeDefinition')<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gi', ":call CocActionAsync('jumpImplementation')<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gr', ":call CocActionAsync('jumpReferences')<CR>", { noremap = true, silent = true })

-- Use K to show documentation in preview window.
vim.api.nvim_set_keymap('n', 'K',  ":call CocActionAsync('doHover')<CR>", { noremap = true, silent = true })

-- Highlight the symbol and its references when holding the cursor.
vim.api.nvim_exec([[autocmd CursorHold * silent call CocActionAsync('highlight')]], false)

-- Symbol renaming.
vim.api.nvim_set_keymap('n', '<leader>n', ":call CocActionAsync('rename')<CR>", { noremap = true })

-- Formatting whole file
vim.api.nvim_set_keymap('n', '<leader>f', ":call CocActionAsync('format')<CR>", { noremap = true, silent = true })
-- Formatting selected code.
vim.api.nvim_set_keymap('x', '<leader>f', ":call CocActionAsync('formatSelected', visualmode())<CR>", { noremap = true })

-- Applying codeAction to the selected region.
-- Example: `<leader>aap` for current paragraph
vim.api.nvim_exec([[xmap <leader>a <Plug>(coc-codeaction-selected)]], false)
vim.api.nvim_exec([[nmap <leader>a <Plug>(coc-codeaction-selected)]], false)

-- Remap keys for applying codeAction to the current buffer.
-- nmap <leader>ac  <Plug>(coc-codeaction)
vim.api.nvim_set_keymap('n', '<leader>ac', ":call CocActionAsync('codeAction', '')<CR>", { noremap = true })
-- Apply AutoFix to problem on the current line.
-- nmap <leader>lf  <Plug>(coc-fix-current)
vim.api.nvim_set_keymap('n', '<leader>lf', ":call CocActionAsync('doQuickFix')<CR>", { noremap = true, silent = true  })

-- Code lens
vim.api.nvim_set_keymap('n', '<leader>al', ":call CocActionAsync('codeLensAction')<CR>", { noremap = true })

-- Map function and class text objects
-- NOTE: Requires 'textDocument.documentSymbol' support from the language server.
vim.api.nvim_set_keymap('x', 'if', ":call coc#rpc#request('selectSymbolRange', [v:true, visualmode(), ['Method', 'Function']])<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('o', 'if', ":call coc#rpc#request('selectSymbolRange', [v:true, '', ['Method', 'Function']])<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', 'af', ":call coc#rpc#request('selectSymbolRange', [v:false, visualmode(), ['Method', 'Function']])<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('o', 'af', ":call coc#rpc#request('selectSymbolRange', [v:false, '', ['Method', 'Function']])<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap('x', 'ic', ":call coc#rpc#request('selectSymbolRange', [v:true, visualmode(), ['Interface', 'Struct', 'Class']])<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('o', 'ic', ":call coc#rpc#request('selectSymbolRange', [v:true, '', ['Interface', 'Struct', 'Class']])<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', 'ac', ":call coc#rpc#request('selectSymbolRange', [v:false, visualmode(), ['Interface', 'Struct', 'Class']])<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('o', 'ac', ":call coc#rpc#request('selectSymbolRange', [v:false, '', ['Interface', 'Struct', 'Class']])<CR>", { noremap = true, silent = true })

vim.api.nvim_exec([[
  " Make <CR> auto-select the first completion item and notify coc.nvim to
  " format on enter, <cr> could be remapped by other vim plugin
  inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  augroup mygroup
    autocmd!
    " Setup formatexpr specified filetype(s).
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder.
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  augroup end

  " Remap <C-f> and <C-b> for scroll float windows/popups.
  if has('nvim-0.4.0') || has('patch-8.2.0750')
    nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
    inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
    vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  endif

  " Use CTRL-S for selections ranges.
  " Requires 'textDocument/selectionRange' support of language server.
  nmap <silent> <C-s> <Plug>(coc-range-select)
  xmap <silent> <C-s> <Plug>(coc-range-select)

  " Add `:Format` command to format current buffer.
  command! -nargs=0 Format :call CocAction('format')

  " Add `:Fold` command to fold current buffer.
  command! -nargs=? Fold :call     CocAction('fold', <f-args>)

  " Add `:OR` command for organize imports of the current buffer.
  command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

  " Add (Neo)Vim's native statusline support.
  " NOTE: Please see `:h coc-status` for integrations with external plugins that
  " provide custom statusline: lightline.vim, vim-airline.
  set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

  " " Mappings for CoCList
  " " Show all diagnostics.
  " nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
  "  Manage extensions.
  " nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
  "  Show commands.
  " nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
  "  Find symbol of current document.
  " nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
  "  Search workspace symbols.
  " nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
  "  Do default action for next item.
  " nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
  "  Do default action for previous item.
  " nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
  "  Resume latest coc list.
  " nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

  " coc-snippets
  " Use <C-l> for trigger snippet expand.
  imap <C-l> <Plug>(coc-snippets-expand)

  " Use <C-j> for select text for visual placeholder of snippet.
  vmap <C-j> <Plug>(coc-snippets-select)

  " Use <C-j> for jump to next placeholder, it's default of coc.nvim
  let g:coc_snippet_next = '<c-j>'

  " Use <C-k> for jump to previous placeholder, it's default of coc.nvim
  let g:coc_snippet_prev = '<c-k>'

  " Use <C-j> for both expand and jump (make expand higher priority.)
  imap <C-j> <Plug>(coc-snippets-expand-jump)

  " Use <leader>x for convert visual selected code to snippet
  xmap <leader>x  <Plug>(coc-convert-snippet)
]], false)
