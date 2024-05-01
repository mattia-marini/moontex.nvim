local config = require("MoonTex.config")
local util = require("MoonTex.util")
local mt_fs = require("MoonTex.fs")


vim.api.nvim_create_user_command("InverseSearch", "lua inverse_search(match_arg(<q-args>))", { nargs = 1 })

--parses parameters to avoid errors when wd path has whitespaces
function match_arg(arg)
  return arg:match("\"(.*)\""), arg:match("\".*\" (%d*)")
end

--forward search
function forward_search()
  vim.fn.jobstart(
    config.skim_path ..
    "/Contents/SharedSupport/displayline -g " ..
    vim.api.nvim_win_get_cursor(0)[1] ..
    " \"" ..
    util.get_buf_status("mainfile_dir") .. "/" .. config.mainfile_name ".pdf\"" ..
    " \"" .. vim.api.nvim_buf_get_name(0) .. "\"", { on_exit = function() print("Forward search done!") end })
end

--invoked by InverseSearch when perfoming inverse search (skim)
function inverse_search(file, line)
  local project_name = vim.fs.basename(mt_fs.get_root(file))

  local server_dir = util.get_server_dir()
  for server in vim.fs.dir(server_dir) do
    if server:match("^" .. project_name) then
      local socket_channel = vim.fn.sockconnect('pipe', server, { rpc = 1 })
      vim.rpcrequest(socket_channel, 'nvim_command', ":lua move_cursor(" .. line .. ")")
      vim.fn.chanclose(socket_channel)
    end
  end
end

--move cursor without errors for out of bound indexes
function move_cursor(line)
  local line_count = vim.api.nvim_buf_line_count(0)
  vim.api.nvim_win_set_cursor(0, { math.max(1, math.min(line, line_count)), 0 })
end

--starts server for backwards search
function start_tex_server()
  local server_dir = util.get_server_dir()

  --local server_dir = vim.fn.serverstart(nvim_servers_path .. "/" .. vim.fn.basename(util.get_buf_status("mainfile_dir")) .. "/")
  --util.set_buf_status("server_path", server_path)
  local project_name = vim.fn.basename(util.get_buf_status("mainfile_dir"))

  local server_number = 0

  for path in vim.fs.dir(server_dir) do
    local curr_n = tonumber(path:match("^" .. project_name .. ".%d"))
    if curr_n then
      if curr_n > server_number then
        server_number = curr_n
      end
    end
  end

  server_number = server_number + 1

  vim.fn.serverstart(server_dir .. "/" .. project_name .. "/" .. server_number)
end

--skim synch
--command: nvim
--args: --headless --noplugin -u <path to installation of MoonTex> -c "InverseSearch \"%file\" %line"
