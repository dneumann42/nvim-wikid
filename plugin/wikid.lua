local wikid = require("wikid")
vim.api.nvim_create_user_command("WikidDashboard", wikid.dashboard, {})
vim.api.nvim_create_user_command("WikidDaily", wikid.daily, {})
