require("MoonTex.search")
require("MoonTex.compile")
require("MoonTex.fs")
require("MoonTex.config")

return {config = function(user_conf)
  local config_table = require("MoonTex.config")
  for key, value in pairs(user_conf) do
    config_table[key]=value
  end
end}
