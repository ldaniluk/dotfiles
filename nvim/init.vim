" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin(stdpath('data') . '/plugged')

" Plug 'ibhagwan/fzf-lua', {'branch': 'main'}
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-telescope/telescope.nvim', {'rev': '0.1.x'}
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'tpope/vim-fugitive'
Plug 'nvim-lualine/lualine.nvim'
Plug 'RRethy/nvim-base16'
Plug 'cormacrelf/dark-notify'
Plug 'neovim/nvim-lspconfig'

Plug 'tpope/vim-abolish'

Plug 'onsails/lspkind.nvim'


Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'akinsho/bufferline.nvim', { 'tag': 'v4.*' }

Plug 'mfussenegger/nvim-dap'
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'mfussenegger/nvim-dap-python'

" Plug 'simrat39/symbols-outline.nvim'
Plug 'stevearc/aerial.nvim'

Plug 'ruifm/gitlinker.nvim'
Plug 'FeiyouG/commander.nvim'


" Plug 'puremourning/vimspector'
Plug 'varnishcache-friends/vim-varnish'

Plug 'duane9/nvim-rg'

Plug 'dstein64/vim-startuptime'

Plug 'aznhe21/actions-preview.nvim'

Plug 'zbirenbaum/copilot.lua'
Plug 'CopilotC-Nvim/CopilotChat.nvim', { 'branch': 'canary' }

" Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

let g:vimspector_base_dir='/Users/ldaniluk/.local/share/nvim/plugged/vimspector'

set cul
"set cuc
set nu
set ignorecase
set smartcase
set termguicolors
set laststatus=3
set signcolumn=yes

lua require('init_vim')


set spell spelllang=en_us

let g:mapleader = "\\"
nmap <Space> \

nnoremap <Leader>h     <CMD>noh<CR>
nnoremap <Leader>t     <CMD>NvimTreeToggle<CR>
nnoremap <Leader>]     <CMD>Telescope lsp_references<CR>
nnoremap <Leader>f     <CMD>Telescope find_files<CR>
nnoremap <Leader>/     <CMD>Telescope live_grep<CR>
nnoremap <Leader>[     <CMD>Telescope grep_string<CR>
nnoremap <Leader><Tab> <CMD>Telescope buffers<CR>
nnoremap <Leader>-     <CMD>Telescope diagnostics<CR>
nnoremap <Leader>e     <CMD>lua vim.diagnostic.open_float(0, {scope="line"})<CR>
nnoremap <Leader><CR>  <CMD>lua require("actions-preview").code_actions()<CR>

nnoremap <Leader>sv    <CMD>source $MYVIMRC<CR>

nnoremap <C-P>         <CMD>Telescope commander<CR>
vnoremap <C-P>         <CMD>Telescope commander<CR>

" imap <silent><script><expr> <C-Space> copilot#Accept("")
" let g:copilot_no_tab_map = v:true
" let g:copilot_workspace_folders = ['~/repos/']

" SymbolsOutlineOpen
" NvimTreeOpen
