--autocommands have to be defined before the ftplugin directory is sourced, since not doing so can result in declaring autocommands afret certain events are triggered
local tex_fs = require("MoonTex.fs")

--sets the main file directory as a tex buffer is opened
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile" }, {
  pattern = {"*.tex"},
  callback = function()
    vim.api.nvim_buf_set_var(0, "main_file_dir", tex_fs.get_root(vim.api.nvim_buf_get_name(0)))
    start_tex_server()
  end
})

--sets buffer specific keymaps, leaving theese free to be used on non tex buffers
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile" }, {
  pattern = {"*.tex"},
  callback = function()

    vim.api.nvim_buf_set_keymap(0, "n", "<space>r", ":lua toggle_compile()<CR>", {noremap=true})
    vim.api.nvim_set_keymap('n', '<space>s', ':lua forward_search()<CR>', {noremap = true})

    vim.api.nvim_create_user_command('MTPrintSkimCommand', 
  function ()
        print("command: nvim")
        print("args: --headless --noplugin -u "..vim.api.nvim_get_var("MoonTex_install_dir")..[[/lua/MoonTex/search.lua -c "InverseSearch \"%file\" %line"]])
  end,
      {})

  end
})
