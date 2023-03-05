require("MoonTex")

local function script_dir()
  local str = debug.getinfo(2, "S").source:sub(2)
  return str:match("(.*/)")
end

--setto la directory di dove è installato il plugin per accedere al file .markdown
print(vim.fs.dirname(vim.fs.dirname(script_dir())))
vim.api.nvim_set_var("MoonTex_install_dir", vim.fs.dirname(vim.fs.dirname(script_dir())))

