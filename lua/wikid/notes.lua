local M = {}

local tools = require('wikid.tools')

M.get_templates_path = function(cfg)
  local dir = vim.fn.expand(cfg.wiki_dir)
  local sub = cfg.templates_subdir == '' and '' or "/" .. cfg.templates_subdir
  vim.cmd("silent !mkdir -p " .. dir .. sub)
  return dir .. sub
end

M.new_template = function(cfg)
  vim.ui.input({ prompt = 'Enter name of new template: ' }, function(input)
    local entry_path = M.get_templates_path(cfg) .. '/' .. input .. '.md'
    vim.cmd('e ' .. entry_path)
  end)
end

M.edit_template = function(cfg)
  local dir = M.get_templates_path(cfg)
  local templates = tools.get_files_in_directory(dir)
  vim.ui.select(templates, { prompt = "Select a template" }, function(itm)
    vim.cmd('e ' .. dir .. '/' .. itm)
  end)
end

return M
