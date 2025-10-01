local function get_buf_status(name)
  local t = vim.api.nvim_buf_get_var(0, "mt_status")
  return t[name]
end

local function set_buf_status(name, val)
  local t = vim.api.nvim_buf_get_var(0, "mt_status")
  t[name] = val
  vim.api.nvim_buf_set_var(0, "mt_status", t)
end


local function get_server_dir()
  return tostring(vim.fn.stdpath("run")):match("(.*/nvim.*)/") .. "/MT_servers"
end

local function hash_to_length(str, length)
  local full_hash = vim.fn.sha256(str) -- 64 hex characters = 32 bytes
  if #full_hash > length then
    return string.sub(full_hash, 1, length)
  elseif #full_hash < length then
    return full_hash .. string.rep("0", length - #full_hash)
  else
    return full_hash
  end
end

local rv = {
  ["get_buf_status"] = get_buf_status,
  ["set_buf_status"] = set_buf_status,
  ["get_server_dir"] = get_server_dir,
  ["hash_to_length"] = hash_to_length
}

return rv
