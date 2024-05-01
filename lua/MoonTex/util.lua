local function get_mainfile()

  local found, rv = pcall(function()
    return vim.api.nvim_buf_get_var(0, "mt_status").mainfile_dir
  end
  )

  return (found and rv or nil)

end
