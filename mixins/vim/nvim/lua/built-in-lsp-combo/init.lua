local use = require('packer').use

use {
   'hrsh7th/nvim-compe',
   requires = {
      {
         'hrsh7th/vim-vsnip',
         config = function()
            vim.api.nvim_exec([[
              " Expand
              imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
              smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'

              " Expand or jump
              imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
              smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

              " Jump forward or backward
              imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
              smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
              imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
              smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

              " Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
              " See https://github.com/hrsh7th/vim-vsnip/pull/50
              nmap        s   <Plug>(vsnip-select-text)
              xmap        s   <Plug>(vsnip-select-text)
              nmap        S   <Plug>(vsnip-cut-text)
              xmap        S   <Plug>(vsnip-cut-text)

              " If you want to use snippet for multiple filetypes, you can `g:vsnip_filetypes` for it.
              let g:vsnip_filetypes = {}
              let g:vsnip_filetypes.javascriptreact = ['javascript']
              let g:vsnip_filetypes.typescriptreact = ['typescript']
              " TODO set up let g:vsnip_snippet_dir =
            ]], false)
         end
      },
      {
         'hrsh7th/vim-vsnip-integ',
      }
   },
   config = function()
      vim.o.completeopt = 'menuone,noselect'
      require('compe').setup {
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
         }
       }
   end
}
use {
   'neovim/nvim-lspconfig',
   config = function()
      local nvim_lsp = require('lspconfig')
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
         local lsp_mapper = function(mode, key, result)
            vim.api.nvim_buf_set_keymap(0, mode, key, '<cmd>lua '..result..'<cr>', {noremap = true, silent = true})
         end
         lsp_mapper('n', 'gd',         'vim.lsp.buf.definition()')
         lsp_mapper('n', 'gD',         'vim.lsp.buf.declaration()')
         lsp_mapper('n', '<leader>D',  'vim.lsp.buf.type_definition()')
         lsp_mapper('n', 'gr',         'vim.lsp.buf.references()')
         lsp_mapper('n', 'gi',         'vim.lsp.buf.implementation()')
         lsp_mapper('n', '<leader>n',         'vim.lsp.buf.rename()')
         lsp_mapper('n', 'K',          'vim.lsp.buf.hover()')
         lsp_mapper('n', 'C-k',        'vim.lsp.buf.signature_help()')
         lsp_mapper('n', '<leader>ca', 'vim.lsp.buf.code_action()')
         lsp_mapper('n', '<leader>d',  'vim.lsp.diagnostic.set_loclist()')
         lsp_mapper('n', '<leader>e',  'vim.lsp.diagnostic.show_line_diagnostics()')
         lsp_mapper('n', '[d',         'vim.lsp.diagnostic.goto_prev()')
         lsp_mapper('n', ']d',         'vim.lsp.diagnostic.goto_next()')

         -- Set some keybinds conditional on server capabilities
         if _client.resolved_capabilities.document_formatting then
            lsp_mapper('n', '<leader>f',  'vim.lsp.buf.formatting()')
         elseif _client.resolved_capabilities.document_range_formatting then
            lsp_mapper('n', '<leader>f',  'vim.lsp.buf.range_formatting()')
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
      -- TODO check if works
      local system_name
      if vim.fn.has("mac") == 1 then
         system_name = "macOS"
      elseif vim.fn.has("unix") == 1 then
         system_name = "Linux"
      elseif vim.fn.has('win32') == 1 then
         system_name = "Windows"
      else
         print("Unsupported system for sumneko")
      end

      local sumneko_cmd
      if vim.fn.executable("lua-language-server") == 1 then
         sumneko_cmd = {"lua-language-server"}
      else
         local sumneko_root_path = vim.fn.getenv("HOME").."/.local/bin/sumneko_lua"
         sumneko_cmd = {sumneko_root_path.."/bin/".. system_name .."/lua-language-server", "-E", sumneko_root_path.."/main.lua" }
      end

      nvim_lsp.sumneko_lua.setup {
         cmd = sumneko_cmd;
         settings = {
            Lua = {
               runtime = {
                  version = 'LuaJIT', -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                  path = vim.split(package.path, ';'), -- Setup your lua path
               },
               diagnostics = {
                  globals = {'vim'}, -- Get the language server to recognize the `vim` global
               },
               workspace = {
                  -- Make the server aware of Neovim runtime files
                  library = {
                     [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                     [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
                  },
               },
            },
         },
         on_attach = on_attach,
      }
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
   end
}
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
   end
}
use { 'nvim-treesitter/playground' }
