vim.api.nvim_buf_set_var(0, "mt_status", {})
vim.opt.wrap = true

local tex_fs = require("moontex.fs")
local util = require("moontex.util")
local search = require("moontex.search")

local function script_dir()
  local str = debug.getinfo(2, "S").source:sub(2)
  return str:match("(.*/)")
end

--setto la directory di dove è installato il plugin per accedere al file .markdown
local d = vim.fs.dirname(vim.fs.dirname(vim.fs.dirname(script_dir())))
vim.api.nvim_set_var("mt_install_dir", d)

--vim.api.nvim_buf_set_var(0, "mt_status", { mainfile_dir = tex_fs.get_root(vim.api.nvim_buf_get_name(0)) })
util.set_buf_status("mainfile_dir", tex_fs.get_root(vim.api.nvim_buf_get_name(0)))
search.start_tex_server()

--sets the main file directory as a tex buffer is opened
--sets buffer specific keymaps, leaving theese free to be used on non tex buffers
vim.api.nvim_buf_set_keymap(0, "n", "<space>r", "", {
  noremap = true,
  callback = function()
    toggle_compile()
  end
})
vim.api.nvim_set_keymap('n', '<space>s', '', {
  noremap = true,
  callback = function()
    forward_search()
  end
})
--headless --clean --cmd "cd /Users/mattia/.local/share/nvim/lazy/moontex.nvim/lua"
---u /Users/mattia/.local/share/nvim/lazy/moontex.nvim/lua/moontex/search.lua -c "InverseSearch \"%file\" %line"
vim.api.nvim_create_user_command('MTPrintSkimCommand',
  function()
    print("command: nvim")
    print("args: --headless --clean --cmd \"cd " .. vim.fs.joinpath(vim.api.nvim_get_var("mt_install_dir"), "/lua\"")
      .. " -u " .. [[./moontex/search.lua -c "InverseSearch \"%file\" %line"]])
  end,
  {})
vim.api.nvim_create_user_command('MTRevealProject',
  function()
    local dir = util.get_buf_status("mainfile_dir")
    local onExit = function(obj)
      if obj.code == 0 then
        print("Ho aperto la directory: " .. dir)
      end
    end
    vim.system({ 'open', util.get_buf_status("mainfile_dir") }, { text = true }, onExit)
  end,
  {})
