# FTerm.nvim

A floating terminal plugin build in lua.

## Usage

### Toggle the terminal

Direct lua call

`:lua require'fterm'.toggle()`

Or create vim cmd map

`command FTermToggle lua require'fterm'.toggle()`

Or create key map

`nnoremap ,,, :lua require'fterm'.toggle()`

### Exec cmd in terminal

Direct lua call

`:lua require'fterm'.exec("ls")`

Or create vim cmd map

`command -nargs=1 FTermExec lua require'fterm'.exec(<args>)`

### Create [vim-test](https://github.com/janko/vim-test) strategy

Add the following to init.vim

```
function! FTermStrategry(cmd)
  call luaeval('require"fterm".exec(_A)', a:cmd)
endfunction

let g:test#custom_strategies = {'fterm': function('FTermStrategry')}
let g:test#strategy = 'fterm'
```
