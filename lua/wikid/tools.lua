local function get_files_in_directory(directory)
  local i, t, popen = 0, {}, io.popen
  local pfile = popen('ls -a "' .. directory .. '"')
  if not pfile then
    return t
  end
  for filename in pfile:lines() do
    if filename ~= "." and filename ~= '..' then
      table.insert(t, filename)
    end
  end
  pfile:close()
  return t
end

local function file_exists(name)
  local f = io.open(name, "r")
  if f ~= nil then
    io.close(f)
    return true
  end
  return false
end

return {
  file_exists,
  get_files_in_directory
}
