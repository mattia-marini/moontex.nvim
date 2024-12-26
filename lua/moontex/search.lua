local config = require("moontex.config")
local util = require("moontex.util")
local mt_fs = require("moontex.fs")


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
    util.get_buf_status("mainfile_dir") .. "/" .. config.mainfile_name .. ".pdf\"" ..
    " \"" .. vim.api.nvim_buf_get_name(0) .. "\"", { on_exit = function() print("Forward search done!") end })
end

--invoked by InverseSearch when perfoming inverse search (skim)
function inverse_search(file, line)
  local project_name = vim.fs.basename(mt_fs.get_root(file))
  local server_dir = util.get_server_dir()

  for server in vim.fs.dir(server_dir) do
    if server:match("^" .. project_name) then
      local full_path = server_dir .. "/" .. server
      local socket_channel = vim.fn.sockconnect('pipe', full_path, { rpc = 1 })
      vim.rpcrequest(socket_channel, 'nvim_command', ":lua move_cursor(" .. line .. ")")
      vim.fn.chanclose(socket_channel)
    end
  end
  vim.cmd(":q!")
end

--move cursor without errors for out of bound indexes
function move_cursor(line)
  local line_count = vim.api.nvim_buf_line_count(0)
  vim.api.nvim_win_set_cursor(0, { math.max(1, math.min(line, line_count)), 0 })
end

--starts server for backwards search
local function start_tex_server()
  local server_dir = util.get_server_dir()

  if not mt_fs.path_exists(server_dir) then create_directory(server_dir) end

  local project_name = vim.fs.basename(util.get_buf_status("mainfile_dir"))

  local server_number = 0

  for path in vim.fs.dir(server_dir) do
    local curr_n = tonumber(path:match("^" .. project_name .. "%.(%d)"))
    if curr_n then
      if curr_n > server_number then
        server_number = curr_n
      end
    end
  end

  server_number = server_number + 1

  vim.fn.serverstart(server_dir .. "/" .. project_name .. "." .. server_number)
end


return {
  start_tex_server = start_tex_server
}
--skim synch
--command: nvim
--args: --headless --noplugin -u <path to installation of moontex> -c "InverseSearch \"%file\" %line"
