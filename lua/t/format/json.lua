local jsonlib = require "rapidjson"
require "meta"

local options_pretty = {pretty=true, sort_keys=true, empty_table_as_array=true}
local options_sort = {sort_keys=true, empty_table_as_array=true}

local getmetatable = debug.getmetatable or getmetatable
local setmetatable = debug.setmetatable or setmetatable

local atom = {
  ["number"]=true,
  ["boolean"]=true,
  ["string"]=true,
}

local function clear(self)
  if type(self)~='table' then return self end
  setmetatable(self, nil)
  for k,v in pairs(self) do clear(v) end
  return self
end

local function __json(x)
  local mt = getmetatable(x or {}) or {}
  local to = mt.__toJSON or mt.__tojson
  if type(to)=='function' then return to(x) end
end

local function __string(x)
  local mt = getmetatable(x or {}) or {}
  local to = mt.__toJSON or mt.__tojson
  if type(to)=='function' then return to(x) end
end

local json
json = setmetatable({
  null=jsonlib.null,
  pretty=function(x) return jsonlib.encode(x, options_pretty) end,
  encode=function(x)
    if type(x)=='string' then return x end
    if type(x)~='table' and type(x)~='userdata' then return jsonlib.encode(x, options_sort) end
    return assert(jsonlib.encode(clear(x), options_sort))
  end,
  decode=function(x) return clear(jsonlib.decode(x)) end,
},{
  __call=function(self, x, deep)
    if type(x)=='function' or type(x)=='thread' or type(x)=='CFunction' then x=tostring(x) end
    if atom[type(x)] then return deep and x or self.encode(x) end
    if x==self.null or type(x)=='nil' then return self.null end
    if type(x)=='userdata' then
      local mt = getmetatable(x or {}) or {}
      local to = mt.__toJSON or mt.__tojson
      if type(to)=='function' then
        x=__json(x)
        if deep then return x end
        return type(x)=='string' and x or self.encode(x)
      end
      return 'userdata'
    end
    if type(x)=='table' then
      local mt = getmetatable(x or {}) or {}
      local to = mt.__toJSON or mt.__tojson
      if type(to)=='function' then
        x=__json(x)
        if deep then return x end
        return self.encode(x)
      end
      for k,v in pairs(x) do x[k]=self(v, true) end
      if deep then return x end
      return type(x)=='string' and x or self.encode(x)
    end
    error('unknownn type' .. type(x))
  end,
})

return json
