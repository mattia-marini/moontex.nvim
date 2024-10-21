--print("lua")
require("moontex.setup")
require("moontex.compile")
require("moontex.search")
require("moontex.fs")
require("moontex.config")

return {config = function(user_conf)
  local config_table = require("moontex.config")
  for key, value in pairs(user_conf) do
    config_table[key]=value
  end
end}
