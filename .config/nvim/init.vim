call plug#begin()

Plug '$HOME/dev/nvim_plugs/pubspec-assist.vim'
Plug 'mattn/webapi-vim'
Plug 'vim-scripts/AnsiEsc.vim'
Plug 'vim-scripts/DrawIt.vim'
Plug 'tjdevries/nlua.nvim'
" Plug 'kdheepak/lazygit.nvim'
Plug 'euclidianAce/BetterLua.vim'
Plug 'dart-lang/dart-vim-plugin'
Plug 'neomake/neomake'
Plug 'thosakwe/vim-flutter'
Plug 'neoclide/coc.nvim', {'branch':'release'}
Plug 'preservim/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'gruvbox-community/gruvbox'
Plug 'itchyny/lightline.vim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
Plug 'jremmen/vim-ripgrep'
Plug 'tpope/vim-fugitive'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'vim-test/vim-test'
Plug 'puremourning/vimspector'
Plug 'szw/vim-maximizer'
Plug 'jiangmiao/auto-pairs'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'Neevash/awesome-flutter-snippets'
Plug 'RobertBrunhage/flutter-riverpod-snippets'
" Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

call plug#end()

" vim-test
let test#strategy = "neovim"
if has('nvim')
    tmap <C-o> <C-\><C-n>
endif

" Remove trailing whitespaces in specified filetypes
autocmd FileType dart autocmd BufWritePre <buffer> %s/\s\+$//e
" autocmd! FileType dart autocmd BufWritePost,BufEnter Neomake! lint<CR>
syntax on
filetype plugin indent on

" NerdCommenter
let g:NERDCreateDefaultMappings = 1
let g:NERDSpaceDelims = 1

" Auto-Pairs
" let g:AutoPairsMapCR = 1
" inoremap <expr> <buffer> <silent> <CR> AutoPairsReturn()
let g:completion_confirm_key = ""
inoremap <expr> <cr> pumvisible() ? "\<Plug>(completion_confirm_completion)" : "\<cr>"

" ColorScheme Configuration
colorscheme gruvbox
if exists('+termguicolors')
        let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
        let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
let gruvbox_contrast_dark = 'hard'
let gruvbox_invert_selection = '0'
" Colors may not be correct if this is not set
set termguicolors
let ayucolor="dark"
hi Normal guibg=NONE ctermbg=NONE

" lightline
let g:lightline = {
	\ 'colorscheme': 'gruvbox',
	\ }

" Sets
set noerrorbells
set nohlsearch
set softtabstop=2
set shiftwidth=2
set expandtab
set autoindent
set nu
set nowrap
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set colorcolumn=80
set number
set relativenumber
set cursorline
set splitbelow
set splitright
set scrolloff=8

" Dart Vim Plugin
let g:dart_style_guide = 2
let g:dart_format_on_save = 1
" let g:dartfmt_options = 

" Nvim LSP
set completeopt=menuone,noinsert,noselect
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
" let g:neomake_dart_lint_maker = {
  " \ 'exe': 'flutter',
  " \ 'args': ['analyze', 'getCwd()'],
  " \ 'errorformat': '%f:%l:%c:%n: %m', }
" let g:neomake_dart_enabled_makers = ['lint']

" Telescope
:lua require('telescope').setup({defaults = {file_sorter = require('telescope.sorters').get_fzy_sorter, prompt_position="top", sorting_strategy="ascending"}})

" Diagnostics
:lua << EOF
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    -- Enable diagnostic message updates in insert mode
    update_in_insert = true,
  }
)
EOF

:lua <<EOF
local nvim_lsp = require('lspconfig')
-- local flutter = require('flutter-tools')
local dart_capabilities = vim.lsp.protocol.make_client_capabilities()
local servers = {'dartls', 'tsserver'}
-- for _, lsp in ipairs(servers) do
--  nvim_lsp[lsp].setup{}
--end
dart_capabilities.textDocument.codeAction = {
    codeActionLiteralSupport = {
        codeActionKind = {
            valueSet = {
                "",
                "quickfix",
                "refactor",
                "refactor.extract",
                "refactor.inline",
                "refactor.rewrite",
                "source",
                "source.organizeImports",
            };
        };
    };
}
-- flutter.setup_lsp{
--   on_attach = on_attach,
--   capabilities = capabilities
-- }
nvim_lsp.dartls.setup{
--    on_attach = dart_attach;
    on_attach = require'completion'.on_attach;
    flags = {allow_incremental_sync = true},
    init_options = {
      onlyAnalyzeProjectsWithOpenFiles = true,
      outline = true,
      flutterOutline = true,
      suggestFromUnimportedLibraries = true,
      closingLabels = true,
    },
--     handlers = {
--       ['dart/textDocument/publishClosingLabels'] = flutter.closing_tags,
--       ['dart/textDocument/publishOutline'] = flutter.outline
--     },
    capabilities = dart_capabilities;  
}
EOF

" TreeSitter
lua require'nvim-treesitter.configs'.setup {highlight = { enable = true }}


function! WinMove(key)
    let t:curwin = winnr()
    exec "wincmd ".a:key
    if (t:curwin == winnr())
	if (match(a:key, '[jk]'))
	    wincmd v
	else
	    wincmd s
	endif
	exec "wincmd ".a:key
    endif
endfunction

nnoremap <silent> <C-h> :call WinMove('h')<CR>
nnoremap <silent> <C-j> :call WinMove('j')<CR>
nnoremap <silent> <C-k> :call WinMove('k')<CR>
nnoremap <silent> <C-l> :call WinMove('l')<CR>

nnoremap <SPACE> <Nop>
let mapleader=" "

" KeyBindings
" xmap <leader>a <Plug>(coc-codeaction-selected)
" nmap <leader>a <Plug>(coc-codeaction-selected)
"nmap <silent> <C-p>

" FZF
" nnoremap <silent> <C-p> :GFiles<cr>

nnoremap <silent> <C-p> :lua require('telescope.builtin').git_files()<CR>

" Snippets
imap <expr> <C-j>   vsnip#available(1)  ? '<Plug>(vsnip-expand)'         : '<C-j>'
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

" Telescope
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>vca :lua require('telescope.builtin').lsp_code_actions()<CR>

" Completion
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-n>" : "\<S-Tab>"

" Flutter
nnoremap <leader>fa :FlutterRun<cr>
nnoremap <leader>fq :FlutterQuit<cr>
nnoremap <leader>fr :FlutterHotReload<cr>
nnoremap <leader>fR :FlutterHotRestart<cr>
nnoremap <leader>fD :FlutterVisualDebug<cr>

nnoremap <leader>vd :lua vim.lsp.buf.definition()<CR>
nnoremap <leader>vi :lua vim.lsp.buf.implementation()<CR>
nnoremap <leader>vsh :lua vim.lsp.buf.signature_help()<CR>
nnoremap <leader>vrr :lua vim.lsp.buf.references()<CR>
nnoremap <leader>vrn :lua vim.lsp.buf.rename()<CR>
nnoremap <leader>vh :lua vim.lsp.buf.hover()<CR>
" nnoremap <leader>vca :lua vim.lsp.buf.code_action()<CR>
nnoremap <leader>vsd :lua vim.lsp.diagnostic.show_line_diagnostics(); vim.lsp.util.show_line_diagnostics()<CR>

" GoTo code navigation.
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)

" Debugger remaps
nnoremap <leader>m :MaximizerToggle!<CR>
nnoremap <leader>dd :call vimspector#Launch()<CR>
nnoremap <leader>dc :call GotoWindow(g:vimspector_session_windows.code)<CR>
nnoremap <leader>dt :call GotoWindow(g:vimspector_session_windows.tagpage)<CR>
nnoremap <leader>dv :call GotoWindow(g:vimspector_session_windows.variables)<CR>
nnoremap <leader>dw :call GotoWindow(g:vimspector_session_windows.watches)<CR>
nnoremap <leader>ds :call GotoWindow(g:vimspector_session_windows.stack_trace)<CR>
nnoremap <leader>do :call GotoWindow(g:vimspector_session_windows.output)<CR>
nnoremap <leader>de :call vimspector#Reset()<CR>

nnoremap <leader>dtcb :call vimspector#CleanLineBreakpoint()<CR>

nmap <leader>dl <Plug>VimspectorStepInto
nmap <leader>dj <Plug>VimspectorStepOver
nmap <leader>dk <Plug>VimspectorStepOut
nmap <leader>d_ <Plug>VimspectorRestart
nnoremap <leader>d<space> :call vimspector#Continue()<CR>

nmap <leader>drc <Plug>VimspectorRunToCursor
nmap <leader>dbp <Plug>VimspectorToggleBreakpoint
nmap <leader>dcbp <Plug>VimspectorToggleConditionalBreakpoint

" Rename symbol
nmap <leader>rn <Plug>(coc-rename)
nnoremap <leader>prw :CocSearch <C-R>=expand("<cword>")<CR><CR>

" Use K to show documentation in preview window
nnoremap <silent> K : call <SID>show_documentation()<CR>

function! s:show_documentation()
	if(index(['vim','help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	else
		call CocActionAsync('doHover')
	endif
endfunction

