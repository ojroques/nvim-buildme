-- nvim-buildme
-- By Olivier Roques
-- github.com/ojroques

-------------------- VARIABLES -----------------------------
local cmd, fn, vim = vim.cmd, vim.fn, vim
local g = vim.g
local fmt = string.format

-------------------- OPTIONS -------------------------------
local opts = {
  debugfile = '.debugme.lua',  -- the debug config file
}

-------------------- HELPERS -------------------------------
local function echo(hlgroup, msg)
  cmd(fmt('echohl %s', hlgroup))
  cmd(fmt('echo "[buildme] %s"', msg))
  cmd('echohl None')
end

-------------------- PUBLIC --------------------------------
local function edit()
  cmd(fmt('edit %s', opts.debugfile))
end

local function debug()
  if not g.nvim_dap then
    echo('ErrorMsg', 'nvim-dap is not loaded')
    return
  end
  if fn.filereadable(opts.debugfile) == 0 then
    echo('WarningMsg', fmt("Debug file '%s' not found", opts.debugfile))
    edit()
    return
  end
  local dap = require('dap')
  local debugcfg = dofile(opts.debugfile)
  dap.run(debugcfg)
  dap.repl.open()
end

-------------------- SETUP ---------------------------------
local function setup(user_opts)
  opts = vim.tbl_extend('keep', user_opts, opts)
end

------------------------------------------------------------
return {
  debug = debug,
  edit = edit,
  setup = setup,
}
