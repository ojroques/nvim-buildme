-- nvim-buildme
-- By Olivier Roques
-- github.com/ojroques

-------------------- VARIABLES -----------------------------
local api, cmd, fn, vim = vim.api, vim.cmd, vim.fn, vim
local bo = vim.bo
local fmt = string.format
local job_id

-------------------- OPTIONS -------------------------------
local opts = {
  buildfile = '.buildme.sh',
  shell = fn.getenv('SHELL'),
}

-------------------- HELPERS -------------------------------
local function echo(hlgroup, msg)
  cmd(fmt('echohl %s', hlgroup))
  cmd(fmt('echo "[buildme] %s"', msg))
  cmd('echohl None')
end

-------------------- INTERFACE -----------------------------
local function build()
  local command = ''
  if fn.filereadable(opts.buildfile) == 0 then
    echo('WarningMsg', 'Build file not found')
    cmd(fmt('edit %s', opts.buildfile))
    cmd(fmt('au BufWritePost <buffer> call jobstart("chmod +x %s")', opts.buildfile))
    return
  end
  if job_id and fn.jobwait({job_id}, 0)[1] == -1 then
    echo('WarningMsg', 'A build job is already running')
    return
  end
  if opts.shell and opts.shell ~= '' then
    command = fmt('%s ', opts.shell)
  end
  cmd(fmt('buffer %d', api.nvim_create_buf(true, true)))
  job_id = fn.termopen(fmt('%s%s', command, opts.buildfile))
end

local function stop()
  if job_id and fn.jobwait({job_id}, 0)[1] == -1 then
    fn.jobstop(job_id)
    echo('None', fmt('Stopped job %s', job_id))
    return
  end
  echo('None', 'No job to stop')
end

-------------------- SETUP ---------------------------------
local function setup(user_opts)
  opts = vim.tbl_extend('keep', user_opts, opts)
end

------------------------------------------------------------
return {
  build = build,
  stop = stop,
  setup = setup,
}
