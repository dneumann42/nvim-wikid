local config = {
  wiki_dir = "~/.wiki",
  daily_date_format = "%m-%d-%Y",
  daily_subdir = "daily"
}

local M = {
  setup_called = false,
  config = config,
}

M.setup = function(args)
  M.setup_called = true
  M.config = vim.tbl_deep_extend("force", M.config, args or {})
end

M.dashboard = function()
  if not M.setup_called then
    return
  end
  require("wikid.dashboard").show_dashboard()
end

M.daily = function()
  if not M.setup_called then
    return
  end
  require("wikid.daily").open_daily_entry(M.config)
end

M.commands = function()
  local commands = { "dashboard", "daily" }
  vim.ui.select(commands, { prompt = "Wikid" }, function(itm)
    M[itm]()
  end)
end

return M
