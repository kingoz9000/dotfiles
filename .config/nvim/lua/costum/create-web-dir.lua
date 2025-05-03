local function create_web_dir()
  local cmd = "web.sh"
  local output = vim.fn.system(cmd)
  vim.notify((output or ""):gsub("%s*$", ""), vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("Web", create_web_dir, {})


