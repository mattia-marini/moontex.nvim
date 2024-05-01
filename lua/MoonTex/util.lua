local function get_buf_status(name)
  local found, rv = pcall(function()
    return vim.api.nvim_buf_get_var(0, "mt_status")[name]
  end
  )

  return (found and rv or nil)
end

local function set_buf_status(name, val)
  local t = vim.api.nvim_buf_get_var(0, "mt_status")
  table.insert(t, name, val)
  vim.api.nvim_buf_set_var(0, "mt_status", t)
end


local function get_server_dir()
  return tostring(vim.fn.stdpath("run")):match("(.*/nvim.*)/") .. "MT_servers"
end

local rv = {
  ["get_buf_status"] = get_buf_status,
  ["set_buf_status"] = set_buf_status,
  ["get_server_dir"] = get_server_dir
}

return rv
