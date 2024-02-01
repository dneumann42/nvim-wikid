local M = {}

M.get_daily_entry_path = function(cfg)
  local dir = vim.fn.expand(cfg.wiki_dir)
  vim.cmd("silent !mkdir -p " .. dir)
  return string.format("%s/%s.md", dir, os.date(cfg.daily_date_format))
end

M.open_daily_entry = function(cfg)
  vim.cmd('e ' .. M.get_daily_entry_path(cfg))
end

return M
