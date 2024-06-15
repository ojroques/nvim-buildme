# nvim-buildme

A Neovim plugin to run a script using the built-in terminal. You can use this
script to build a project, run tests, start containers...

## Usage
The plugin checks for a Buildme script and runs it in a terminal buffer. By
default, this is a shell script named `.buildme.sh` located in the current
working directory.

To run a Buildme job:
```lua
require('buildme').run()
```

To pass arguments to the Buildme script:
```lua
require('buildme').run({'arg1', 'arg2'})
```

To stop a running Buildme job:
```lua
require('buildme').stop()
```

To edit the Buildme script:
```lua
require('buildme').edit()
```

To jump to the Buildme buffer:
```lua
require('buildme').jump()
```

## Configuration
Here are all available options with their default settings:
```lua
require('buildme').setup {
  script = '.buildme.sh',  -- the Buildme script to execute
  interpreter = 'bash',    -- the interpreter to use (bash, python, ...)
  wincmd = '',             -- a command to run prior to a Buildme job (split, vsplit, ...)
}
```
