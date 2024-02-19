local config = {
  wiki_dir = "~/.wiki",
  daily_date_format = "%m-%d-%Y",
  daily_subdir = "daily",
  templates_subdir = "templates",

  -- uncomplete tasks will show in new daily notes
  carry_forward_tasks = true,
}

local Wikid = {
  setup_called = false,
  config = config,
}

local commands = {}
local function cmd(name, fn)
  Wikid[name] = function() return fn(Wikid.config) end
  table.insert(commands, name)
end

function Wikid.setup(args)
  Wikid.config = vim.tbl_deep_extend("force", Wikid.config, args or {})
end

local tools = require("core.tools")

local Cache = require("core.wikid_cache")
local Daily = require("wikid.daily")
local Dashboard = require("wikid.dashboard")
local Notes = require("wikid.notes")

Cache.setup(Wikid.config.wiki_dir)
Dashboard.setup(Wikid.config)

cmd('dashboard', Dashboard.show_dashboard)
cmd('daily', Daily.open_daily_entry)
cmd('daily_entries', Daily.open_old_daily_entry)
cmd('new_template', Notes.new_template)
cmd('edit_template', Notes.edit_template)
cmd('new_note_from_template', Notes.new_note_from_template)
cmd('new_note', Notes.new_note)

function Wikid.commands()
  vim.ui.select(commands, { prompt = "Wikid" }, function(itm)
    if Wikid[itm] and type(Wikid[itm]) == 'function' then
      Wikid[itm]()
    end
  end)
end

return Wikid
