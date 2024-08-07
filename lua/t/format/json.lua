local t = require "t"
local jsonlib = require "rapidjson"

local options_pretty = {pretty=true, sort_keys=true, empty_table_as_array=true}
local options_sort = {sort_keys=true, empty_table_as_array=true}

local function clear(self)
  if type(self)~='table' then return self end
  setmetatable(self, nil)
  for k,v in pairs(self) do clear(v) end
  return self
end

return t.object({
  pretty=function(x) return jsonlib.encode(x, options_pretty) end,
  encode=function(x) return jsonlib.encode(clear(x), options_sort) end,
  decode=function(x) return clear(jsonlib.decode(x)) end,
  __call=function(self, x)
    if type(x)=='string' then x=self.decode(x); end
    if type(x)=='table' then return clear(x) end
    return x
  end,
}):factory()
