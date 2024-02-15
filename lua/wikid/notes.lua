local Notes = {}

local tools = require('core.tools')
local platform = require('core.platform')
local join = tools.join_paths

function Notes.get_templates_path(cfg)
  local dir = vim.fn.expand(cfg.wiki_dir)
  local sub = cfg.templates_subdir == '' and '' or "/" .. cfg.templates_subdir
  platform.make_directory(join(dir, sub))
  return join(dir, sub)
end

function Notes.new_template(cfg)
  vim.ui.input({ prompt = 'Enter name of new template: ' }, function(input)
    if input == '' or input == nil then
      return
    end
    local entry_path = join(Notes.get_templates_path(cfg), input .. '.md')
    platform.make_directory(tools.basepath(entry_path))
    vim.cmd('e ' .. entry_path)
  end)
end

function Notes.edit_template(cfg)
  local dir = Notes.get_templates_path(cfg)
  local templates = tools.get_files_in_directory(dir)
  vim.ui.select(templates, { prompt = "Select a template" }, function(itm)
    if itm == '' or itm == nil then
      return
    end
    platform.make_directory(tools.basepath(join(dir, itm)))
    vim.cmd('e ' .. join(dir, itm))
  end)
end

function Notes.new_note(cfg, template)
  vim.ui.input({ prompt = "Note name: " }, function(input)
    local f = join(cfg.wiki_dir, input .. '.md')

    platform.make_directory(tools.basepath(f))
    vim.cmd('e ' .. f)

    local lines = tools.splitlines(template or "")
    vim.api.nvim_buf_set_text(0, 0, 0, 0, 0, lines)
  end)
end

function Notes.new_note_from_template(cfg)
  local dir = Notes.get_templates_path(cfg)
  local templates = tools.get_files_in_directory(dir)
  vim.ui.select(templates, { prompt = "Select a template for note" }, function(itm)
    if itm == '' or itm == nil then
      return
    end

    local f = io.open(join(dir, itm), "r")
    local templ
    if f then
      templ = f:read("*a")
      f:close()
    end

    Notes.new_note(cfg, templ)
  end)
end

return Notes
