-- nvim-buildme
-- By Olivier Roques
-- github.com/ojroques

-------------------- VARIABLES -----------------------------
local api, cmd, fn, vim = vim.api, vim.cmd, vim.fn, vim
local fmt = string.format
local nkeys = api.nvim_replace_termcodes('<C-\\><C-n>', true, false, true)
local job_buffer, job_id

-------------------- OPTIONS -------------------------------
local opts = {
  buildfile = '.buildme.sh',
  interpreter = 'bash',
  wincmd = '',
}

-------------------- HELPERS -------------------------------
local function echo(hlgroup, msg)
  cmd(fmt('echohl %s', hlgroup))
  cmd(fmt('echo "[buildme] %s"', msg))
  cmd('echohl None')
end

local function is_running()
  return job_id and fn.jobwait({job_id}, 0)[1] == -1
end

-------------------- PUBLIC --------------------------------
local function edit()
  local autocmd = 'au BufWritePost <buffer> call jobstart("chmod +x %s")'
  cmd(fmt('edit %s', opts.buildfile))
  cmd(fmt(autocmd, opts.buildfile))
end

local function build()
  if is_running() then
    echo('ErrorMsg', fmt('A build job is already running (id: %d)', job_id))
    return
  end
  if fn.filereadable(opts.buildfile) == 0 then
    echo('WarningMsg', fmt('Build file %s not found', opts.buildfile))
    edit()
    return
  end
  -- Format interpreter string
  local interpreter = ''
  if opts.interpreter ~= '' then
    interpreter = fmt('%s ', opts.interpreter)
  end
  -- Create scratch buffer
  if not job_buffer or fn.buflisted(job_buffer) == 0 then
    job_buffer = api.nvim_create_buf(true, true)
  end
  -- Move to buffer
  local job_window = fn.bufwinnr(job_buffer)
  if job_window == -1 then
    if opts.wincmd ~= '' then
      cmd(opts.wincmd)
    end
    cmd(fmt('buffer %d', job_buffer))
  else
    cmd(fmt('%d wincmd w', job_window))
  end
  -- Unset modified flag
  fn.setbufvar(job_buffer, '&modified', 0)
  -- Start build job
  job_id = fn.termopen(fmt('%s%s', interpreter, opts.buildfile))
  -- Exit terminal mode
  api.nvim_feedkeys(nkeys, 'n', false)
end

local function stop()
  if is_running() then
    fn.jobstop(job_id)
    echo('None', fmt('Stopped job %d', job_id))
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
  edit = edit,
  build = build,
  stop = stop,
  setup = setup,
}
