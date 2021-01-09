{ config, lib, pkgs, ... }:

{
  config = {
    home-manager.users.kazimazi = { pkgs, ... }: {
      programs = {
        neovim =
        with pkgs;
        let customPlugins = {
          suda = vimUtils.buildVimPlugin {
            name = "suda";
            src = fetchgit {
              url= "https://github.com/lambdalisue/suda.vim";
              rev =  "45f88d4f0699c054af775b82c87b93b439da0a22";
              sha256 = "sha256-D41msPIhHq9ndsvH3lfl+Aw1uQZUDjHjJh8nUxYS7io=";
            };
          };
          #indent-blankline = vimUtils.buildVimPlugin {
          #  name = "indent-blankline.nvim";
          #  src = fetchgit {
          #    url= "https://github.com/lukas-reineke/indent-blankline.nvim";
          #    rev =  "435b16e0ac2cd1856a509b03ef830d554bdd092e";
          #    sha256 = "sha256-fL7GyfhJQPabXkkogZRoYKSISEfGCCizU3+RqnIq6QE=";
          #  };
          #};
        }; in {
          enable = true;
          package = neovim-nightly;
          extraPackages = with pkgs; [
            nodePackages.vscode-json-languageserver-bin
            ( rWrapper.override { packages = with rPackages; [ languageserver ]; } ) gnumake gcc
            #rnix-lsp nixpkgs-fmt
            fzf ripgrep
            clang-tools
          ];
          extraConfig = ''
            set nu rnu

            set ignorecase smartcase

            set expandtab
            set shiftwidth=4
            set smartindent
            set softtabstop=4

            set scrolloff=5 sidescrolloff=5 sidescroll=1 nostartofline

            set noswapfile
            set nobackup
            set nowritebackup

            "set nowrap
            "set list
            "set listchars=eol:↴
            "set listchars+=tab:│⋅
            "set listchars+=trail:•
            "set listchars+=extends:❯
            "set listchars+=precedes:❮
            "set listchars+=nbsp:_
            "set listchars+=space:⋅
            "set showbreak=↳⋅
            set conceallevel=2
            set concealcursor=n

            let mapleader=' '
            let maplocaleleader='\'

            nmap <leader>w :w<CR>
            nmap <leader>q :q<CR>

            nmap <leader>1 :Ex<CR>
            nmap <leader>2 :e .<CR>

            nmap tt tabe<CR>

            vmap < <gv
            vmap > >gv

            nmap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
            nmap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

            nmap Y y$

	          " Suda
	          let g:suda_smart_edit = 1
          '';
          plugins = with pkgs.vimPlugins; [
            { plugin = base16-vim;
              config = ''
                function! s:base16_customize() abort
                  call Base16hi("Function", g:base16_gui0D, "", g:base16_cterm0D, "", "italic", "")
                  call Base16hi("Todo", g:base16_gui0A, g:base16_gui01, g:base16_cterm0A, g:base16_cterm01, "bold", "")
                  call Base16hi("Comment", g:base16_gui03, "", g:base16_cterm03, "", "italic", "")
                endfunction

                augroup on_change_colorschema
                  autocmd!
                  autocmd ColorScheme * call s:base16_customize()
                augroup END
                colorscheme base16-tomorrow-night
                let base16colorspace=256
                set termguicolors
              '';
            }
            vim-nix
            vim-polyglot

            #nvim-treesitter
            #nvim-lspconfig
            #{ plugin = completion-nvim;
            #  config = ''
            #    " Set completeopt to have a better completion experience
            #    set completeopt=menuone,noinsert,noselect

            #    " Avoid showing message extra message when using completion
            #    set shortmess+=c
            #    lua require'lspconfig'.hls.setup{ on_attach=require'completion'.on_attach }
            #  '';
            #}
            #completion-treesitter

            fugitive
            vim-airline
            vim-airline-themes
            #indentLine
            #customPlugins.indent-blankline
            { plugin = coc-nvim;
              config = ''
                set hidden
                set cmdheight=2
                set updatetime=300
                set shortmess+=c
                set signcolumn=yes
                nmap <silent><expr> <c-space> coc#refresh()

                " Make <CR> auto-select the first completion item and notify coc.nvim to
                " format on enter, <cr> could be remapped by other vim plugin
                inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

                " Use `[g` and `]g` to navigate diagnostics
                " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
                nmap <silent> [g <Plug>(coc-diagnostic-prev)
                nmap <silent> ]g <Plug>(coc-diagnostic-next)

                " GoTo code navigation.
                nmap <silent> gd <Plug>(coc-definition)
                nmap <silent> gy <Plug>(coc-type-definition)
                nmap <silent> gi <Plug>(coc-implementation)
                nmap <silent> gr <Plug>(coc-references)

                " Use K to show documentation in preview window.
                nnoremap <silent> K :call <SID>show_documentation()<CR>

                function! s:show_documentation()
                  if (index(['vim','help'], &filetype) >= 0)
                    execute 'h '.expand('<cword>')
                  elseif (coc#rpc#ready())
                    call CocActionAsync('doHover')
                  else
                    execute '!' . &keywordprg . " " . expand('<cword>')
                  endif
                endfunction
                " Highlight the symbol and its references when holding the cursor.

                autocmd CursorHold * silent call CocActionAsync('highlight')

                " Symbol renaming.
                nmap <leader>rn <Plug>(coc-rename)

                " haskell
                "autocmd User CocNvimInit call coc#config('languageserver', {
                "    \ 'haskell': {
                "    \    'command': 'haskell-language-server-wrapper',
                "    \    'args': ['--lsp'],
                "    \    'rootPatterns': ['*.cabal', 'stack.yaml', 'package.yaml', 'hie.yaml'],
                "    \    'filetypes': ['hs', 'lhs', 'haskell', 'lhaskell'],
                "    \    'initializationOptions': {
                "    \        'languageServerHaskell' : {
                "    \            'hlintOn': true,
                "    \            'maxNumberOfProblems': 10,
                "    \            'completionSnippetsOn': true
                "    \        },
                "    \    },
                "    \ }
                "\ })
              '';
            }
            coc-pairs
            coc-highlight
            coc-json
	          customPlugins.suda
            { plugin = fzf-vim;
              config = ''
                nmap <leader>f :Files<CR>
                nmap <leader>g :GFiles<CR>
                nmap <leader>b :Buffers<CR>
                nmap <leader>l :Lines<CR>
                nmap <leader>r :Rg<CR>
              '';
            }
          ];
          viAlias = true;
          vimAlias = true;
          vimdiffAlias = true;
          withNodeJs = true;
        };
      };
      home.file = {
        ".config/nvim/coc-settings.json".source = (pkgs.writeText "coc-settings" ''
          {
            "languageserver": {
              "haskell": {
                "command": "haskell-language-server-wrapper",
                "args": ["--lsp"],
                "rootPatterns": [".stack.yaml", ".hie-bios", "BUILD.bazel", "cabal.config", "package.yaml"],
                "filetypes": ["hs", "lhs", "haskell"],
                "initializationOptions": {
                  "languageServerHaskell": {
                    "hlintOn": true,
                    "maxNumberOfProblems": 10,
                    "completionSnippetsOn": true
                  }
                }
              }
            }
          }
        '');
      };
    };
  };
}
