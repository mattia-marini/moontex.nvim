local tex_fs = require("MoonTex.fs")

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile" }, {
  pattern = {"*.tex"},
  callback = function()
    --print("Inizializzo server")
    --vim.api.nvim_echo({{"Inizializzo server", "Underlined"}}, true, {})
    vim.api.nvim_buf_set_var(0, "main_file_dir", tex_fs.get_root(vim.api.nvim_buf_get_name(0)))
    start_tex_server()
  end
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile" }, {
  pattern = {"*.tex"},
  callback = function()

    vim.api.nvim_buf_set_keymap(0, "n", "<space>r", ":lua toggle_compile()<CR>", {noremap=true})
    vim.api.nvim_set_keymap('n', '<space>s', ':lua forward_search()<CR>', {noremap = true})

  end
})
