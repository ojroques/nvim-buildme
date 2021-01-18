# nvim-buildme

A Neovim plugin to build or run a project using the built-in terminal. It is
written entirely in Lua.

_**Note**: this plugin is mainly for my own use. I won't add new features if I
don't need them. Feel free to submit PRs or fork the plugin though._

## Installation

#### With Packer
```lua
cmd 'packadd packer.nvim'
return require('packer').startup(function()
  use {'ojroques/nvim-buildme'}
end)
```

#### With Plug
```vim
call plug#begin()
Plug 'ojroques/nvim-buildme'
call plug#end()
```

## Usage
The plugin checks for a build file and runs it in a terminal buffer. By default,
that file is a shell script named `.buildme.sh` located in the current working
directory.

If you're using Neovim built-in LSP client, the working directory should be
automatically set to the project root. Otherwise you may want to check
[vim-rooter](https://github.com/airblade/vim-rooter).

To run a build job:
```vim
:BuildMe<CR>
```

To stop a running build job:
```vim
:BuildMeStop<CR>
```

To edit the build file:
```vim
:BuildMeEdit<CR>
```

## Configuration
You can pass options to the provided `setup()` function. Here are all available
options with their default settings:
```lua
require('buildme').setup {
  buildfile = '.buildme.sh',  -- the build file to execute
  interpreter = 'bash',       -- the interpreter to use (bash, python, ...)
  wincmd = '',                -- a command to run prior to a build job (split, vsplit, ...)
}
```

## License
[LICENSE](./LICENSE)
