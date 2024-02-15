local fmt, insert = string.format, table.insert
local tools = require("core.tools")

local Dashboard = {
  buffer_number = -1,
  buffer_name = "WIKID_DASHBOARD",
  last_opened = {},
}

function Dashboard.is_buffer_visible()
  return vim.api.nvim_call_function("bufwinnr", { Dashboard.buffer_number }) ~= -1
end

local function h(heading, value)
  return string.rep('#', value or 1) .. ' ' .. heading
end

function Dashboard.setup(cfg)
  local cache = require("core.wikid_cache")
  Dashboard.last_opened = vim.deepcopy(cache).get_or('last_opened', {})

  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    pattern = { "*.md" },
    callback = function(o)
      local bp = tools.relative_path(vim.fn.expand(cfg.wiki_dir), o.file)
      tools.insert_or_move_to_front(Dashboard.last_opened, bp)
      require("core.wikid_cache").update { last_opened = Dashboard.last_opened }
    end,
  })
end

function Dashboard.generate_dashboard_lines(cfg)
  local t = {
    h("Dashboard"),
    "",
    h("Recent files", 2),
  }
  for i = 1, math.min(#Dashboard.last_opened, 5) do
    insert(t, fmt("[%s](%s)", Dashboard.last_opened[i], Dashboard.last_opened[i]))
  end
  return t
end

function Dashboard.open_buffer(cfg)
  if Dashboard.buffer_number == -1 or not Dashboard.is_buffer_visible() then
    vim.api.nvim_command(fmt("botright vsplit %s", Dashboard.buffer_name))

    Dashboard.buffer_number = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(0, 0, -1, true, {})
    vim.api.nvim_buf_set_text(0, 0, 0, 0, 0, Dashboard.generate_dashboard_lines())
    vim.api.nvim_buf_set_option(0, 'filetype', 'markdown')
    vim.opt_local.readonly = true -- make readonly
  end
end

function Dashboard.show_dashboard(cfg)
  Dashboard.open_buffer()
end

return Dashboard
