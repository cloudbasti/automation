# Ansible Development Guide

## Testing Connection to Ansible Hosts
```bash
ansible -i inventory.yml all -m ping
```

## Linting Ansible Files
```bash
# Install ansible-lint
sudo apt-get install ansible-lint

# Lint an Ansible file
ansible-lint filename.yml

# Lint the current file in Vim
:!ansible-lint -f pep8 %
```

## Linting YAML Files
```bash
# Install yamllint
sudo apt-get install yamllint

# Lint a YAML file
yamllint file2lint.yml

# Lint the current file in Vim
:!yamllint %
```

## Vim Configuration for YAML Files
Add to your `.vimrc`:
```vim
syntax on
set background=dark
colorscheme torte
set cursorline
set number
filetype plugin indent on
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

# Fix indentation with \f in normal mode
autocmd FileType yaml nnoremap <leader>f gg=G
```


