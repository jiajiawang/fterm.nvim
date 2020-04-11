# fterm.nvim

A floating terminal plugin build in pure lua.

## Configuration

Call config method in `init.vim` (optional)
```
lua require'fterm'.config({
    \ position="top",
    \ width=100,
    \ height=20,
    \ commands=true})
```

### position

Specify the position of the floating window.\
Available options are "top", "bottom", "left" and "right".\
Default is `"right"`.

### width

Specify the width of the floating window when its position is "left" or
"right".\
Default is `80`.

### height

Specify the height of the floating window when its position is "top" or
"bottom".\
Default is `20`.

### commands

Specify if the following vim commands to be created.\
`:FTermToggle` - toggle terminal window\
`:FTermExec` - exec cmd in terminal window\
Default is `false`.

## Usage

### Toggle the terminal

Direct lua call\
`:lua require'fterm'.toggle()`

Or create vim cmd map\
`command FTermToggle lua require'fterm'.toggle()`

Or create key map\
`nnoremap ,,, :lua require'fterm'.toggle()`

### Exec cmd in terminal

Direct lua call\
`:lua require'fterm'.exec("ls")`

Or create vim cmd map\
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
