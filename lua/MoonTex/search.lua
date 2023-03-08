local config = require("MoonTex.config")
local mt_fs = require("MoonTex.fs")


vim.api.nvim_create_user_command("InverseSearch", "lua inverse_search(match_arg(<q-args>))", {nargs=1})

--parses parameters to avoid errors when wd path has whitespaces
function match_arg(arg)
   return arg:match("\"(.*)\""),  arg:match("\".*\" (%d*)")
end

--forward search
function forward_search()
  vim.fn.jobstart("/Applications/Skim.app/Contents/SharedSupport/displayline -g "..vim.api.nvim_win_get_cursor(0)[1].." \""..vim.api.nvim_buf_get_var(0,"main_file_dir").."/main.pdf\"".." \""..vim.api.nvim_buf_get_name(0).."\"", {on_exit=function() print("Forward search done!") end})
end

--invoked by InverseSearch when perfoming inverse search (skim)
function inverse_search(file, line)
  
  local socket = mt_fs.get_root(file)
  print(socket.."/"..config.server_name)
  local socket_channel = vim.fn.sockconnect('pipe', socket.."/"..config.server_name, {rpc = 1})

  vim.rpcrequest(socket_channel, 'nvim_command', ":lua move_cursor("..line..")")
  
  vim.fn.chanclose(socket_channel)
end

--move cursor without errors for out of bound indexes
function move_cursor(line)
  local line_count = vim.api.nvim_buf_line_count(0)
  vim.api.nvim_win_set_cursor(0,{ math.max( 1, math.min(line,line_count) ) , 0})
end

--starts server for backwards search
function start_tex_server()
  if not mt_fs.is_in_dir(vim.api.nvim_buf_get_var(0, "main_file_dir"), config.server_name) then
    vim.fn.serverstart(vim.api.nvim_buf_get_var(0, "main_file_dir").."/"..config.server_name)
  end
end


--skim synch
--command: nvim
--args: --headless --noplugin -u <path to installation of MoonTex> -c "InverseSearch \"%file\" %line"
