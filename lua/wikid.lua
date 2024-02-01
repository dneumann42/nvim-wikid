-- main module file
local dashboard_module = require("wikid.dashboard")
local daily_module = require("wikid.daily")

---@class Config
---@field opt string Your config option
local config = {
  wiki_dir = "~/.wiki",
  daily_date_format = "%m-%d-%Y",
  daily_subdir = "daily"
}

---@class MyModule
local M = {}

---@type Config
M.config = config

---@param args Config?
-- you can define your setup function here. Usually configurations can be merged, accepting outside params and
-- you can also put some validation here for those.
M.setup = function(args)
  M.config = vim.tbl_deep_extend("force", M.config, args or {})
end

M.dashboard = function()
  dashboard_module.show_dashboard()
end

M.daily = function()
  daily_module.open_daily_entry(config)
end

return M
