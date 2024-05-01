local config = require("MoonTex.config")

--returns true if file is in directory
local function is_in_dir(directory, file)
    for dir in vim.fs.dir(directory) do
      if dir == file then return true end
    end
  return false
end

--prints every file in the current directory (directory of the file opened by the buffer)
local function print_curr_dir()
  for dir in vim.fs.dir(vim.fs.dirname(vim.api.nvim_buf_get_name(0))) do
    print(dir)
  end
end

--return the folder containing the whole latex project
local function get_root(path)

  if vim.fs.basename(path) == config.mainfile_name..".tex" then
    return vim.fs.dirname(path)
  end

  local curr_path =  vim.fs.dirname(path)
  local depth = 0

  while depth < config.max_search_depth and vim.fs.basename(curr_path)~=config.workspace_folder_name do

    if is_in_dir(curr_path, config.mainfile_name .. ".tex") then return curr_path end

    curr_path = vim.fs.dirname(curr_path)
    depth = depth + 1
  end
  --print("Mainfile not detected, falling back to current file")
  vim.api.nvim_echo({{"Mainfile not detected, falling back to current file", "Underlined"}}, true, {})
  return vim.fs.dirname(path)
end


function path_exists(path)
    local stat = vim.uv.fs_stat(path)
    return stat --and stat.type == "directory"
end

function create_directory(path)

    --if path_exists(path)then print("cartella esiste") end
    local ok, err = vim.uv.fs_mkdir(path , 493) -- 493 is the octal representation of 0755 permissions
    if ok then
        print("Directory created successfully!")
    else
        print("Failed to create directory:", err)
    end
end


local fn = {
  ["is_in_dir"] = is_in_dir,
  ["print_curr_dir"] =print_curr_dir,
  ["get_root"] = get_root,
  ["path_exists"] = path_exists,
  ["create_directory"] = create_directory
}

return fn
