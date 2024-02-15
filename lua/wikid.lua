local config = {
  wiki_dir = "~/.wiki",
  daily_date_format = "%m-%d-%Y",
  daily_subdir = "daily",
  templates_subdir = "templates",
}

local Wikid = {
  setup_called = false,
  config = config,
}

local commands = {}
local function cmd(name, fn)
  Wikid[name] = fn
  table.insert(commands, name)
end

function Wikid.setup(args)
  Wikid.config = vim.tbl_deep_extend("force", Wikid.config, args or {})
end

local Daily = require("wikid.daily")
local Dashboard = require("wikid.dashboard")
local Notes = require("wikid.notes")

cmd('dashboard', function() Dashboard.show_dashboard() end)
cmd('daily', function() Daily.open_daily_entry(Wikid.config) end)
cmd('new_template', function() Notes.new_template(Wikid.config) end)
cmd('edit_template', function() Notes.edit_template(Wikid.config) end)
cmd('new_note_from_template', function() Notes.new_note_from_template(Wikid.config) end)
cmd('new_note', function() Notes.new_note(Wikid.config) end)

function Wikid.commands()
  vim.ui.select(commands, { prompt = "Wikid" }, function(itm)
    if Wikid[itm] and type(Wikid[itm]) == 'function' then
      Wikid[itm]()
    end
  end)
end

return Wikid
