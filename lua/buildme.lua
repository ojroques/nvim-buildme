-- nvim-buildme
-- By Olivier Roques
-- github.com/ojroques

-------------------- VARIABLES -----------------------------
local tkeys = vim.api.nvim_replace_termcodes('<C-\\><C-n>G', true, false, true)
local job_buffer, job_id
local M = {}

-------------------- OPTIONS -------------------------------
M.options = {
  script = '.buildme.sh',  -- the Buildme script to execute
  interpreter = 'bash',    -- the interpreter to use (bash, python, ...)
  wincmd = '',             -- a window command to run prior to a Buildme job
}

-------------------- PRIVATE -------------------------------
local function buffer_exists()
  return job_buffer and vim.fn.buflisted(job_buffer) == 1
end

local function job_running()
  return job_id and vim.fn.jobwait({job_id}, 0)[1] == -1
end

local function job_exit(job_id, exit_code, _)
  local level = exit_code == 0 and vim.log.levels.INFO or vim.log.levels.ERROR
  local msg = string.format('Buildme job %d has exited with code %d', job_id, exit_code)
  vim.notify(msg, level)
end

-------------------- PUBLIC --------------------------------
function M.edit()
  vim.cmd(string.format('edit %s', M.options.script))
end

function M.jump()
  if not buffer_exists() then
    vim.notify('No Buildme buffer', vim.log.levels.WARN)
    return
  end

  -- Jump to the buffer window if it exists
  local job_window = vim.fn.bufwinnr(job_buffer)
  if job_window ~= -1 then
    vim.cmd(string.format('%d wincmd w', job_window))
    return
  end

  -- Run window command if defined
  if M.options.wincmd ~= '' then
    vim.cmd(M.options.wincmd)
  end

  vim.cmd(string.format('buffer %d', job_buffer))
end

function M.run(args)
  if job_running() then
    vim.notify(string.format('Buildme job %d is already running', job_id), vim.log.levels.WARN)
    return
  end

  if vim.fn.filereadable(M.options.script) == 0 then
    vim.notify(string.format("Buildme script '%s' not found", M.options.script), vim.log.levels.WARN)
    M.edit()
    return
  end

  -- Create scratch buffer
  if not buffer_exists() then
    job_buffer = vim.api.nvim_create_buf(true, true)
  end

  -- Jump to buffer
  M.jump()

  -- Configure buffer
  vim.api.nvim_set_option_value('filetype', 'buildme', {buf = job_buffer})
  vim.api.nvim_set_option_value('modified', false, {buf = job_buffer})
  vim.api.nvim_buf_set_name(job_buffer, 'buildme://job')

  -- Format arguments
  local a = ''
  if args and #args > 0 then
    a = string.format(' %s', table.concat(args, ' '))
  end

  -- Start job
  local cmd = string.format('%s %s%s', M.options.interpreter, M.options.script, a)
  job_id = vim.fn.termopen(cmd, {on_exit = job_exit})

  -- Exit terminal mode
  vim.api.nvim_feedkeys(tkeys, 'n', false)
end

function M.stop()
  if not job_running() then
    vim.notify('No Buildme job to stop', vim.log.levels.INFO)
    return
  end

  vim.fn.jobstop(job_id)
end

-------------------- SETUP ---------------------------------
function M.setup(user_options)
  if user_options then
    M.options = vim.tbl_extend('force', M.options, user_options)
  end
end

------------------------------------------------------------
return M
