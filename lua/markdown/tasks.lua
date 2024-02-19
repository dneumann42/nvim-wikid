local tools = require("core.tools")

local function is_line_task(line)
  local idx = 1
  local indent = 1

  while idx < #line do
    local ch = line:sub(idx, idx)
    if ch == '-' or ch == '+' then
      indent = idx - 1
      idx = #line
    end
    idx = idx + 1
  end

  return (line:sub(indent + 1, indent + 1) == '-' or line:sub(indent + 1, indent + 1) == '+') and
      line:sub(indent + 2, indent + 2) == ' ' and line:sub(indent + 3, indent + 3) == '[' and
      line:sub(indent + 5, indent + 5) == ']', indent
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
  extract_tasks = extract_tasks,
  extract_completed_tasks = extract_completed_tasks,
  extract_uncompleted_tasks = extract_uncompleted_tasks,
}
