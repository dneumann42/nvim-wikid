local tools = require("core.tools")

local Enum = require('plenary.enum')

local TaskState = Enum {
  'Pending',
  'Completed'
}


local function is_line_task(line)
  local idx = 1
  local indent = 1

  while idx < #line do
    local ch = line:sub(idx, idx)
    if ch == '-' or ch == '+' then
      indent = idx
      idx = #line
    end
    idx = idx + 1
  end

  return (line:sub(indent, indent) == '-' or line:sub(indent, indent) == '+') and
      line:sub(indent + 1, indent + 1) == ' ' and line:sub(indent + 2, indent + 2) == '[' and
      line:sub(indent + 4, indent + 4) == ']', indent
end

local function get_task_state(line)
  local is_task, indent = is_line_task(line)
  if not is_task then
    return nil
  end

  local ch = line:sub(indent + 3, indent + 3)
  if ch == ' ' then
    return TaskState.Pending
  elseif ch == 'x' or ch == 'X' then
    return TaskState.Completed
  end
  return nil
end

local function toggle_task_state()
  local line = vim.api.nvim_get_current_line()
  local is_task, indent = is_line_task(line)

  if not is_task then
    return
  end

  local current_state = get_task_state(line)
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  local new_chr = line:sub(indent + 3, indent + 3)

  if current_state == TaskState.Pending then
    new_chr = 'X'
  elseif current_state == TaskState.Completed then
    new_chr = ' '
  end

  local n = tools.replace_char(line, indent + 3, new_chr)
  vim.api.nvim_buf_set_lines(0, row - 1, row, true, { n })
end

local function extract_tasks(doc)
  local lines = tools.splitlines(doc)
  local tasks = {}
  for ln = 1, #lines do
    local line = lines[ln]
    local is_task, indent = is_line_task(line)
    if is_task then
      local t = setmetatable({
        text = line:sub(indent + 1, #line),
        line = ln,
        indent = indent,
        state = string.lower(line:sub(indent + 4, indent + 4))
      }, {
        __tostring = function(self)
          return string.rep(' ', self.indent) .. self.text
        end
      })
      table.insert(tasks, t)
    end
  end
  return tasks
end

local function extract_uncompleted_tasks(doc)
  return tools.filter(extract_tasks(doc), function(it)
    return it.state == ' '
  end)
end

local function extract_completed_tasks(doc)
  return tools.filter(extract_tasks(doc), function(it)
    return it.state ~= ' '
  end)
end

return {
  TaskState = TaskState,
  toggle_task_state = toggle_task_state,
  extract_tasks = extract_tasks,
  extract_completed_tasks = extract_completed_tasks,
  extract_uncompleted_tasks = extract_uncompleted_tasks,
}
