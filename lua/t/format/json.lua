local t = require "t"
local jsonlib = require "rapidjson"

local options_pretty = {pretty=true, sort_keys=true, empty_table_as_array=true}
local options_sort = {sort_keys=true}

return t.object({
  pretty=function(x) return jsonlib.encode(x, options_pretty) end,
  encode=function(x) return jsonlib.encode(x, options_sort) end,
  decode=jsonlib.decode,
  __call=function(self, x)
    if type(x)=='string' then return self.decode(x) end
    if type(x)=='table' then return x end
  end,
}):factory()
