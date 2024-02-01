local fmt = string.format

---@class CustomModule
local M = {
  buffer_number = -1,
  buffer_name = "WIKID_DASHBOARD",
}

M.is_buffer_visible = function()
  return vim.api.nvim_call_function("bufwinnr", { M.buffer_number }) ~= -1
end

M.open_buffer = function()
  if M.buffer_number == -1 or not M.is_buffer_visible() then
    vim.api.nvim_command(fmt("botright vsplit %s", M.buffer_name))
    vim.opt_local.readonly = true -- make readonly
    M.buffer_number = vim.api.nvim_get_current_buf()
  end
end

---@return string
M.show_dashboard = function()
  M.open_buffer()
end

return M
