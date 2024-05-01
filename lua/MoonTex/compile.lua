local config = require("MoonTex.config")
local util = require("MoonTex.util")
local tex_fs = require("MoonTex.fs")

--starts/stops continuous conpile with latekmk
util.set_buf_status("compiling", false)

function toggle_compile()
  if util.get_buf_status("compiling") == false then
    util.set_buf_status("compiling", true)
    vimtex_compile_start()
  else
    util.set_buf_status("compiling", false)
    vimtex_compile_stop()
  end
end

--starts continuous conpile with latekmk
function vimtex_compile_start()
  local mainfile_dir = util.get_buf_status("mainfile_dir")
  if mainfile_dir == nil then
    print("Coundn't resolve mainfile path")
    return
  end

  vim.api.nvim_echo({ { "Compiling...", "Substitute" } }, true, {})
  vim.cmd("silent w")
  --print("cd "..vim.api.nvim_buf_get_var(0,"main_file_dir").." && latexmk -interaction=nonstopmode -r "..vim.api.nvim_get_var("MoonTex_install_dir").."/.latexmkrc ".. config.main_file_name)
  compile_channel_id = vim.fn.jobstart(
  "cd \"" ..
  mainfile_dir ..
  "\" && latexmk -interaction=nonstopmode -r " ..
  vim.api.nvim_get_var("MoonTex_install_dir") .. "/.latexmkrc " .. config.main_file_name,
  { on_exit = function() vim.api.nvim_echo({ { "Compiling stopped!", "Substitute" } }, true, {}) end })
end

--starts continuous conpile with latekmk
function vimtex_compile_stop()
  vim.fn.jobstop(compile_channel_id)
end
