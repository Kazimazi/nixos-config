set nu rnu

set ignorecase smartcase

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set smartindent

set scrolloff=5
set sidescrolloff=5
set sidescroll=1

set noswapfile
set nobackup
set nowritebackup

set signcolumn=auto:5

let mapleader=' '

nmap <leader>w :w<CR>
nmap <leader>q :q<CR>

nmap <leader>1 :Ex<CR>
nmap <leader>2 :e .<CR>

nmap <leader>t :tabnew<CR>

vmap < <gv
vmap > >gv

nmap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
nmap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

nmap Y y$

""" base16-vim
function! s:base16_customize() abort
	call Base16hi('Function', g:base16_gui0D, '', g:base16_cterm0D, '', 'italic', '')
	call Base16hi('Todo', g:base16_gui0A, g:base16_gui01, g:base16_cterm0A, g:base16_cterm01, 'bold', '')
	call Base16hi('Comment', g:base16_gui03, '', g:base16_cterm03, '', 'italic', '')
endfunction

augroup on_change_colorscheme
	autocmd!
	autocmd ColorScheme * call s:base16_customize()
augroup END

colorscheme base16-tomorrow-night
let base16colorspace=256
set termguicolors

""" fzf
nmap <leader>ff :Files<CR>
nmap <leader>fg :GFiles<CR>
nmap <leader>fl :Lines<CR>
nmap <leader>fr :Rg<CR>
nmap <leader>b :Buffers<CR>

""" telescope
"" Find files using Telescope command-line sugar.
"nnoremap <leader>ff <cmd>Telescope find_files<cr>
"nnoremap <leader>fg <cmd>Telescope live_grep<cr>
"nnoremap <leader>fb <cmd>Telescope buffers<cr>
"nnoremap <leader>fh <cmd>Telescope help_tags<cr>

"" Using lua functions
"nnoremap <leader>f <cmd>lua require('telescope.builtin').find_files()<cr>
"nnoremap <leader>g <cmd>lua require('telescope.builtin').git_files()<cr>
"nnoremap <leader>r <cmd>lua require('telescope.builtin').grep_string()<cr>
"nnoremap <leader>s <cmd>lua require('telescope.builtin').live_grep()<cr>
"nnoremap <leader>b <cmd>lua require('telescope.builtin').buffers()<cr>
"nnoremap <leader>h <cmd>lua require('telescope.builtin').help_tags()<cr>

""" nvim-comple
""" lsp + nvim-comple
lua << EOF
vim.o.completeopt = 'menuone,noselect'
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    vsnip = true;
    nvim_lsp = true;
    nvim_lua = true;
    spell = true;
    tags = true;
    snippets_nvim = true;
    treesitter = true;
  };
}

-- Shorthand
local nvim_lsp = require('lspconfig')

-- Completion engine
local completion = require('compe')

local on_attach = function(_client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = true; -- enable virtual text
      signs = true, -- show signs
      update_in_insert = true, -- delay update diagnostics
    }
  )

  -- Shorthand
  local mapper = function(mode, key, result)
    vim.api.nvim_buf_set_keymap(0, mode, key, '<cmd>lua '..result..'<cr>', {noremap = true, silent = true})
  end

  -- Mappings.
  mapper('n', 'gd',         'vim.lsp.buf.definition()')
  mapper('n', 'gD',         'vim.lsp.buf.declaration()')
  mapper('n', 'gr',         'vim.lsp.buf.references()')
  mapper('n', 'gi',         'vim.lsp.buf.implementation()')
  mapper('n', 'rn',         'vim.lsp.buf.rename()')
  mapper('n', 'K',          'vim.lsp.buf.hover()')
  mapper('n', 'C-k',        'vim.lsp.buf.signature_help()')
  mapper('n', '<leader>ca', 'vim.lsp.buf.code_action()')
  mapper('n', '<leader>d',  'vim.lsp.diagnostic.set_loclist()')
  mapper('n', '<leader>e',  'vim.lsp.diagnostic.show_line_diagnostics()')
  mapper('n', '[d',         'vim.lsp.diagnostic.goto_prev()')
  mapper('n', ']d',         'vim.lsp.diagnostic.goto_next()')

  -- Set some keybinds conditional on server capabilities
  if _client.resolved_capabilities.document_formatting then
    mapper('n', '<leader>x',  'vim.lsp.buf.formatting()')
  elseif _client.resolved_capabilities.document_range_formatting then
    mapper('n', '<leader>z',  'vim.lsp.buf.range_formatting()')
  end

  -- Set autocommands conditional on server_capabilities
  if _client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=Blue
      hi LspReferenceText cterm=bold ctermbg=red guibg=Blue
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=Blue
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

-- nvim_lsp.diagnosticls.setup {
--    filetypes = {'haskell', 'javascript'},
--    on_attach = on_attach,
-- }
nvim_lsp.tsserver.setup {
   on_attach = on_attach,
}
nvim_lsp.html.setup {
   on_attach = on_attach,
}
nvim_lsp.vimls.setup {
   on_attach = on_attach,
}
nvim_lsp.rnix.setup {
   on_attach = on_attach,
}
nvim_lsp.hls.setup {
   on_attach = on_attach,
   root_dir = nvim_lsp.util.root_pattern('.git'),
}
nvim_lsp.pyls.setup {
   on_attach = on_attach,
}
EOF

""" nvim-treesitter
" there are so much more...
" extra modules too
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = 'maintained', -- one of 'all', 'maintained' (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { 'c', 'rust' },  -- list of language that will be disabled
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
    enable = true
  }
}
EOF

" sicko mode
" ty treesitter
set foldlevel=99
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
"or in lua
"vim.cmd("set foldmethod=expr foldexpr=nvim_treesitter#foldexpr()")
