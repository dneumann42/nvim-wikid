local Daily = {}

local tools = require('core.tools')
local platform = require('core.platform')

local Tasks = require("markdown.tasks")

function Daily.get_daily_dir(cfg)
  local dir = vim.fn.expand(cfg.wiki_dir)
  local sub = cfg.daily_subdir == '' and '' or "/" .. cfg.daily_subdir
  local path = tools.join_paths(dir, sub)
  platform.make_directory(path)
  return path
end

function Daily.get_daily_entry_path(cfg)
  return string.format(
    "%s/%s.md", Daily.get_daily_dir(cfg), os.date(cfg.daily_date_format))
end

function Daily.get_daily_entries(cfg)
  local tbl = tools.get_files_in_directory(Daily.get_daily_dir(cfg))
  table.sort(tbl, function(x, y) return x > y end)
  return tbl
end

function Daily.open_daily_entry(cfg)
  local entry_path = Daily.get_daily_entry_path(cfg)
  local add_content = not tools.file_exists(entry_path)
  vim.cmd('e ' .. entry_path)

  local tasks = {}

  if cfg.carry_forward_tasks then
    local ds = Daily.get_daily_entries(cfg)
    if #ds > 0 then
      local path = tools.join_paths(Daily.get_daily_dir(cfg), ds[1])
      local contents = tools.file_contents(path)
      if contents ~= nil then
        tasks = Tasks.extract_uncompleted_tasks(contents)
      end
    end
  end

  local lines = {
    "# Daily - " .. os.date(cfg.daily_date_format),
    ""
  }

  for _, task in pairs(tasks) do
    table.insert(lines, tostring(task))
  end

  if add_content then
    local buffer_number = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(buffer_number, 0, 10, false, lines)
  end
end

return Daily
