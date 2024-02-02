local dashboard_module = require("wikid.dashboard")
local daily_module = require("wikid.daily")

local config = {
  wiki_dir = "~/.wiki",
  daily_date_format = "%m-%d-%Y",
  daily_subdir = "daily"
}

local M = {
  setup_called = false
}

M.config = config

M.setup = function(args)
  M.setup_called = true
  M.config = vim.tbl_deep_extend("force", M.config, args or {})
end

M.dashboard = function()
  assert(M.setup_called)
  dashboard_module.show_dashboard()
end

M.daily = function()
  assert(M.setup_called)
  daily_module.open_daily_entry(M.config)
end

return M
