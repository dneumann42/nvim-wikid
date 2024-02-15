local tools = require("core.tools")

local Cache = {}
local wiki_path

function Cache.cache_file_path()
  return vim.fn.resolve(vim.fn.expand(tools.join_paths(wiki_path, ".wikid.lua")))
end

function Cache.setup(wiki_dir)
  wiki_path = wiki_dir
  local f = io.open(Cache.cache_file_path(), 'r')
  if f then
    local ok, value = pcall(function()
      return load(f:read("*a"))()
    end)
    if ok then
      for k, v in pairs(value) do
        Cache[k] = v
      end
    else
      print(ok, value)
    end
    f:close()
  end
end

function Cache.update(sub_tbl)
  for k, v in pairs(vim.deepcopy(sub_tbl or {})) do
    Cache[k] = v
  end
  local p = Cache.cache_file_path()
  local f = io.open(p, "w")
  if f then
    local save = {}
    for k, v in pairs(Cache) do
      if type(v) ~= "function" then
        save[k] = v
      end
    end
    f:write('return ' .. vim.inspect(save))
    f:close()
  end
end

function Cache.get_or(key, default)
  if Cache[key] == nil then
    Cache.update({ [key] = default })
  end
  return Cache[key]
end

return Cache
