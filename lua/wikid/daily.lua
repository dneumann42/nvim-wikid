local M = {}

local function file_exists(name)
  local f = io.open(name, "r")
  if f ~= nil then
    io.close(f)
    return true
  end
  return false
end

M.get_daily_entry_path = function(cfg)
  local dir = vim.fn.expand(cfg.wiki_dir)
  local sub = cfg.daily_subdir == '' and '' or "/" .. cfg.daily_subdir
  vim.cmd("silent !mkdir -p " .. dir .. sub)
  return string.format(
    "%s/%s.md", dir .. sub, os.date(cfg.daily_date_format))
end

M.open_daily_entry = function(cfg)
  local entry_path = M.get_daily_entry_path(cfg)
  local add_content = not file_exists(entry_path)
  vim.cmd('e ' .. entry_path)

  if add_content then
    local buffer_number = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(
      buffer_number, 0, 10, false,
      { "# Daily - " .. os.date(cfg.daily_date_format) }
    )
  end
end

return M
