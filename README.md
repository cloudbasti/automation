# test connection to ansible hosts 
ansible -i inventory.yml all -m ping

# ansible-lint
sudo apt-get install ansible-lint
ansible-lint filename.yml
:!ansible-lint -f pep8 % (inside vim)

# LINTING YAML Files:
sudo apt-get install yamllint (a linter for YAML files)
yamllint file2lint.yml
:!yamllint % (inside Vim)

# useful configuration of vimrc file for YAML files

syntax on
set background=dark
colorscheme torte
set cursorline
set number
filetype plugin indent on

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
# fix indentation with \f in normal mode in VIM:
autocmd FileType yaml nnoremap <leader>f gg=G


