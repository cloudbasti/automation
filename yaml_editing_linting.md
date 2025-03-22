# YAML Editing & Linting Guide

## YAML Linting

### Linting YAML Files
```bash
# Install yamllint
sudo apt-get install yamllint

# Lint a YAML file
yamllint file2lint.yml

# Lint the current file in Vim
:!yamllint %
```

## Vim Configuration for YAML Files

### Add to your `.vimrc`:
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

### Helpful Vim Commands for YAML/Ansible

```vim
# Remove all trailing whitespace in file
:%s/\s\+$//e

# Convert tabs to spaces
:retab

# Jump to matching bracket/parenthesis
%

# Toggle line numbers
:set number!

# Show YAML syntax errors
:SyntasticCheck
```

## Best Practices for YAML Files

1. Use consistent indentation (2 spaces recommended)
2. Avoid tabs - use spaces instead
3. Keep lines under 80 characters when possible
4. Use comments (#) to document complex sections
5. Validate YAML files before committing changes
6. Group related configuration items together
7. Use anchors (&) and aliases (*) for repeated content
