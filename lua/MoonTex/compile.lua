local config = require("MoonTex.config")
local util = require("MoonTex.util")
local tex_fs = require("MoonTex.fs")

--starts/stops continuous conpile with latekmk
--
util.set_buf_status("compiling", false)
print("settato stato compiling")
function toggle_compile()
  --print(util.get_buf_status("compiling"))
  vim.cmd("echo b:mt_status")
  if util.get_buf_status("compiling") == false then
    print("inizio a compilare")
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

  local compile_command = "cd \"" ..
    mainfile_dir ..
    "\" && latexmk -interaction=nonstopmode -r " ..
    vim.api.nvim_get_var("mt_install_dir") .. "/.latexmkrc " .. config.mainfile_name .. ".tex"

  print("COMPILE command: " .. compile_command)

  local compile_channel_id = vim.fn.jobstart(
    compile_command,
    { on_exit = function() vim.api.nvim_echo({ { "Compiling stopped!", "Substitute" } }, true, {}) end })

  util.set_buf_status("compile_channel_id", compile_channel_id)
end

--starts continuous conpile with latekmk
function vimtex_compile_stop()
  local compile_channel_id = util.get_buf_status("compile_channel_id")
  if compile_channel_id then
    vim.fn.jobstop(compile_channel_id)
  else
    print("Errore! Nessuna compilazione da fermare")
  end
end
