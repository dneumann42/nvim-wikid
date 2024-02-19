local wikid = require("wikid")
local tools = require("core.tools")

for _, command in pairs(wikid.cmds) do
  -- local xs = tools.
  local words = tools.split_underline(command)
  local s = 'Wikid'
  for _, word in pairs(words) do
    s = s .. string.upper(word:sub(1, 1)) .. word:sub(2, #word)
  end
  vim.api.nvim_create_user_command(s, wikid[command], {})
end
