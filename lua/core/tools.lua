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

local function splitlines(str)
  local lines = {}
  for s in str:gmatch("[^\r\n]+") do
    table.insert(lines, s)
  end
  return lines
end

local function basepath(str, sep)
  sep = sep or '/'
  return str:match("(.*" .. sep .. ")")
end

local function join_paths(...)
  local xs = { ... }
  local s = ""
  for i = 1, #xs do
    s = s .. xs[i]
    if i < #xs then
      s = s .. '/'
    end
  end
  return vim.fn.resolve(s)
end

local function relative_path(base, path)
  local a, b = vim.fn.resolve(vim.fn.expand(base)), vim.fn.resolve(path)
  return string.sub(b, #a + 2, #b)
end

local function table_contains(tbl, itm)
  for i = 1, #tbl do
    if tbl[i] == itm then
      return true
    end
  end
  return false
end

local function insert_or_move_to_front(tbl, itm)
  if table_contains(tbl, itm) then
    for i = 1, #tbl do
      if tbl[i] == itm then
        table.remove(tbl, i)
        break
      end
    end
  end
  table.insert(tbl, 1, itm)
end

return {
  file_exists = file_exists,
  get_files_in_directory = get_files_in_directory,
  splitlines = splitlines,
  join_paths = join_paths,
  basepath = basepath,
  relative_path = relative_path,
  insert_or_move_to_front = insert_or_move_to_front,
}
