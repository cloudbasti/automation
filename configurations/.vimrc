syntax on
set background=dark
colorscheme torte
set cursorline
set number
filetype plugin indent on
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
" Fix indentation with in normal mode
autocmd FileType yaml nnoremap <leader>f gg=G
