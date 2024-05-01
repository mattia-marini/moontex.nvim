--[=[
print("ftplugin")
require("MoonTex")

--aux function to get the directory from wich a lua script is executed
local function script_dir()
  local str = debug.getinfo(2, "S").source:sub(2)
  return str:match("(.*/)")
end

--stores the dir in which MoonTex is installed to make .latexmkrc file available
vim.api.nvim_set_var("MoonTex_install_dir", vim.fs.dirname(vim.fs.dirname(script_dir())))
--]=]
--
require("MoonTex")
