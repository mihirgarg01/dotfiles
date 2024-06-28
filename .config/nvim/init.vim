" Specify a directory for plugins
call plug#begin('~/.config/nvim/plugged')

" Plugin definitions
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'tpope/vim-fugitive'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'liuchengxu/vista.vim'
Plug 'tpope/vim-commentary'

" Initialize plugin system
call plug#end()

" Basic settings
set number                " Show line numbers
syntax on                 " Enable syntax highlighting
set tabstop=4             " Number of spaces that a <Tab> in the file counts for
set shiftwidth=4          " Number of spaces to use for each step of (auto)indent
set expandtab             " Use spaces instead of tabs
set mouse=a               " Enable mouse support

" Set cursor shape in different modes
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50

" Enable transparency
highlight Normal guibg=none ctermbg=none

" Key mappings
nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <C-p> :Files<CR>
nnoremap <C-t> :Vista<CR>

" Lightline settings
set laststatus=2
set noshowmode
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ }

" Treesitter settings
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"c", "cpp", "lua", "python", "javascript", "html", "css"}, -- specify the languages you need
  highlight = {
    enable = true,
  },
}
EOF

" LSP settings
lua <<EOF
local nvim_lsp = require('lspconfig')

local servers = { 'pyright', 'tsserver' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {}
end
EOF

" Completion settings
lua <<EOF
local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'buffer' },
    { name = 'path' },
  }
})
EOF
