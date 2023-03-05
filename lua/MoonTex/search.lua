local config = require("MoonTex.config")
local mt_fs = require("MoonTex.fs")

vim.api.nvim_create_user_command("InverseSearch", "lua inverse_search(<f-args>)", {nargs='*'})


function forward_search()
  vim.fn.jobstart("/Applications/Skim.app/Contents/SharedSupport/displayline -g "..vim.api.nvim_win_get_cursor(0)[1].." "..vim.api.nvim_buf_get_var(0,"main_file_dir").."/main.pdf".." "..vim.api.nvim_buf_get_name(0), {on_exit=function() print("Forward search done!") end})
end


function inverse_search(file, line)
  
  local socket = mt_fs.get_root(file)
  print(socket)
  local socket_channel = vim.fn.sockconnect('pipe', socket.."/"..config.server_name, {rpc = 1})
  --print(socket_channel)
  --vim.rpcnotify(socket_channel, "stampa_rpc") 
  --local result = vim.rpcrequest(socket_channel, "nvim_echo(\"prova\")")
  --print(vim.rpcrequest(socket_channel, 'nvim_command', ":echom \"ciao\""))
  --vim.rpcnotify(socket_channel, 'nvim_command', ":"..line.."<CR>")
  --vim.rpcnotify(socket_channel, 'nvim_win_set_cursor', {0 ,43, 0})
  --vim.rpcnotify(socket_channel, 'nvim_command', ":lua vim.api.nvim_win_set_cursor(0,{43,2})")
  --vim.rpcnotify(socket_channel, 'vim.api.nvim_win_set_cursor', {0 ,{43, 0}})
  --vim.rpcrequest(socket_channel, 'nvim_win_set_cursor', 0, {43, 0})
  --vim.rpcnotify(socket_channel, 'nvim_command', ":echom \""..file.." "..line.."\"")
  --vim.rpcnotify(socket_channel, 'nvim_input', "<Esc>5G10l")

  --vim.rpcrequest(socket_channel, 'nvim_command', ":echom \""..file.." "..line.."\"")
  vim.rpcrequest(socket_channel, 'nvim_command', ":lua move_cursor("..line..")")
  
  vim.fn.chanclose(socket_channel)
  --print(vim.fn.serverstart("~/.config/nvim/plugin/MoonTex"))
  --vim.cmd([[echo rpcrequest(7, 'nvim_eval', '"Hello " . "world!"')]])
end


function move_cursor(line)
  local line_count = vim.api.nvim_buf_line_count(0)
  vim.api.nvim_win_set_cursor(0,{ math.max( 1, math.min(line,line_count) ) , 0})
end

--comandi per skim
--comando: nvim
--argomenti: --headless --noplugin -u /Users/mattia/.config/nvim/lua/MoonTex/server_start.lua -c "InverseSearch "%file" %line"
