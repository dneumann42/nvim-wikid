local Daily = {}

local tools = require('core.tools')
local platform = require('core.platform')

Daily.get_daily_entry_path = function(cfg)
  local dir = vim.fn.expand(cfg.wiki_dir)
  local sub = cfg.daily_subdir == '' and '' or "/" .. cfg.daily_subdir
  local path = tools.join_paths(dir, sub)
  platform.make_directory(path)
  return string.format(
    "%s/%s.md", path, os.date(cfg.daily_date_format))
end

Daily.open_daily_entry = function(cfg)
  local entry_path = Daily.get_daily_entry_path(cfg)
  local add_content = not tools.file_exists(entry_path)
  vim.cmd('e ' .. entry_path)

  if add_content then
    local buffer_number = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(
      buffer_number, 0, 10, false,
      { "# Daily - " .. os.date(cfg.daily_date_format) }
    )
  end
end

return Daily
