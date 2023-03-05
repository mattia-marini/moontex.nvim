local config = require("MoonTex.config")

local function is_in_dir(directory, file)
    for dir in vim.fs.dir(directory) do
      if dir == file then return true end
    end
  return false
end

local function print_curr_dir()
  for dir in vim.fs.dir(vim.fs.dirname(vim.api.nvim_buf_get_name(0))) do
    print(dir)
  end
end

local function get_root(path)
  
  if vim.fs.basename(path) == config.main_file_name then
    return vim.fs.dirname(path)
  end

  local curr_path =  vim.fs.dirname(path)
  local depth = 0

  while depth < config.max_search_depth and vim.fs.basename(curr_path)~=config.workspace_folder_name do

    if is_in_dir(curr_path, config.main_file_name) then return  curr_path end

    curr_path = vim.fs.dirname(curr_path)
    depth = depth + 1
  end
  --print("Mainfile not detected, falling back to current file")
  vim.api.nvim_echo({{"Mainfile not detected, falling back to current file", "Underlined"}}, true, {})
  return vim.fs.dirname(path)
end

--setta il file main

local fn = {
  ["is_in_dir"] = is_in_dir,
  ["print_curr_dir"] =print_curr_dir,
  ["get_root"] = get_root
}

return fn
