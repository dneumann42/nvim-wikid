local fmt = string.format

local OS = 'Linux'
local uname = vim.loop.os_uname()
local os = uname.sysname
if os == 'Darwin' or os == 'Linux' then
  OS = os
else
  OS = (os:find "Windows" and true or false) and 'Windows' or OS
end

local mkdir_cmd = ({
  Linux = 'mkdir -p',
  Darwin = 'mkdir -p',
  Windows = 'mkdir',
})[OS]

local function make_directory(path)
  vim.cmd(fmt("silent !%s ", mkdir_cmd) .. path)
end

return {
  make_directory = make_directory
}
