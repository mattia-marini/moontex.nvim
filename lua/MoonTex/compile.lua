local config = require("MoonTex.config")
local tex_fs = require("MoonTex.fs")
--inizializza il socket per ricevere messaggi dall lettore pdf
local server_started = false


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

function vimtex_compile_start()
  
  if vim.api.nvim_buf_get_var(0,"main_file_dir")==nil then print("Coundn't resolve mainfile path") return end

  vim.api.nvim_echo({{"Compiling...", "Substitute"}}, true, {})
  vim.cmd("silent w")
  compile_channel_id=vim.fn.jobstart("cd "..vim.api.nvim_buf_get_var(0,"main_file_dir").." && latexmk -interaction=nonstopmode -r "..vim.api.nvim_get_var("MoonTex_install_dir").."/.latexmkrc ".. config.main_file_name, {on_exit = function() vim.api.nvim_echo({{"Compiling stopped!", "Substitute"}}, true, {}) end})

end

function vimtex_compile_stop()
  vim.fn.jobstop(compile_channel_id)
  --vim.fn.chansend(compile_channel_id, "<C-c>")
  --vim.fn.chanclose(compile_channel_id)
end

function start_tex_server()
  if not tex_fs.is_in_dir(vim.api.nvim_buf_get_var(0, "main_file_dir"), config.server_name) then
    vim.fn.serverstart(vim.api.nvim_buf_get_var(0, "main_file_dir").."/"..config.server_name)
  end
end

--[[
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = "*.tex"
  callback = function()
    print("FILETYPE: tex")
  end
})
--]]
--


