--[=[
vim.api.nvim_buf_set_var(0, "mt_status", { })

require("moontex")
local tex_fs = require("moontex.fs")
local util = require("moontex.util")

local function script_dir()
  local str = debug.getinfo(2, "S").source:sub(2)
  return str:match("(.*/)")
end

--setto la directory di dove è installato il plugin per accedere al file .markdown
print(vim.fs.dirname(vim.fs.dirname(script_dir())))
vim.api.nvim_set_var("moontex_install_dir", vim.fs.dirname(vim.fs.dirname(script_dir())))
--vim.api.nvim_buf_set_var(0, "mt_status", { mainfile_dir = tex_fs.get_root(vim.api.nvim_buf_get_name(0)) })
util.set_buf_status("mainfile_dir", tex_fs.get_root(vim.api.nvim_buf_get_name(0)))


--sets the main file directory as a tex buffer is opened
vim.api.nvim_buf_set_var(0, "mt_status", { mainfile_dir = tex_fs.get_root(vim.api.nvim_buf_get_name(0)) })
start_tex_server()

--sets buffer specific keymaps, leaving theese free to be used on non tex buffers
vim.api.nvim_buf_set_keymap(0, "n", "<space>r", ":lua toggle_compile()<CR>", { noremap = true })
vim.api.nvim_set_keymap('n', '<space>s', ':lua forward_search()<CR>', { noremap = true })

vim.api.nvim_create_user_command('MTPrintSkimCommand',
  function()
    print("command: nvim")
    print("args: --headless --noplugin -u " ..
      vim.api.nvim_get_var("moontex_install_dir") .. [[/lua/moontex/search.lua -c "InverseSearch \"%file\" %line"]])
  end,
  {})
]=]--

require("moontex")
