local function math_env()
  --P(vim.treesitter.get_captures_at_cursor(0))
  local cursor_position = vim.api.nvim_win_get_cursor(0)          
  local node = vim.treesitter.get_node({0, {cursor_position[1]-1, cursor_position[2]}, true})

  while node ~= nill do 
    --P(node:type())text_mode
    if(node:type() == 'text_mode')then return false end
    if(node:type() == 'displayed_equation' or node:type() == 'math_environment' or node:type() == 'inline_formula')then return true end
    node = node:parent()
  end
  
  return false
end

local function context()
  --P(vim.treesitter.get_captures_at_cursor(0))
  local cursor_position = vim.api.nvim_win_get_cursor(0)          
  local node = vim.treesitter.get_node({0, {cursor_position[1]-1, cursor_position[2]}, true})
  
  if math_env() then return "math" end

  while node ~= nill do 
  
    if node:type() == "generic_environment" then 

      local env_name = node:field("begin")[1]:field("name")[1]:field("text")[1]:field("word")[1]
      local row, start_column = env_name:start()

      local _,end_column  = env_name:end_()
      return(vim.api.nvim_buf_get_lines(0, row, row+1, false)[1]:sub(start_column+1, end_column))

    end
    node = node:parent()
  end
return nil
end

local m = {["context"] = context}

return m
