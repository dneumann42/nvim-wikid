vim.api.nvim_create_user_command("WikidDashboard", require("wikid").dashboard, {})
vim.api.nvim_create_user_command("Daily", require("wikid").daily, {})
