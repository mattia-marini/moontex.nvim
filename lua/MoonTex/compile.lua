local config = require("MoonTex.config")
local tex_fs = require("MoonTex.fs")

--starts/stops continuous conpile with latekmk
local compile_running = false
function toggle_compile()
  if compile_running == false then
    compile_running = true
    vimtex_compile_start()
  else
    compile_running = false
    vimtex_compile_stop()
  end
end

--starts continuous conpile with latekmk
function vimtex_compile_start()
  
  if vim.api.nvim_buf_get_var(0,"main_file_dir")==nil then print("Coundn't resolve mainfile path") return end

  vim.api.nvim_echo({{"Compiling...", "Substitute"}}, true, {})
  vim.cmd("silent w")
  --print("cd "..vim.api.nvim_buf_get_var(0,"main_file_dir").." && latexmk -interaction=nonstopmode -r "..vim.api.nvim_get_var("MoonTex_install_dir").."/.latexmkrc ".. config.main_file_name)
  compile_channel_id=vim.fn.jobstart("cd \""..vim.api.nvim_buf_get_var(0,"main_file_dir").."\" && latexmk -interaction=nonstopmode -r "..vim.api.nvim_get_var("MoonTex_install_dir").."/.latexmkrc ".. config.main_file_name, {on_exit = function() vim.api.nvim_echo({{"Compiling stopped!", "Substitute"}}, true, {}) end})

end

--starts continuous conpile with latekmk
function vimtex_compile_stop()
  vim.fn.jobstop(compile_channel_id)
end


