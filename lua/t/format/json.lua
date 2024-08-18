local jsonlib = require "rapidjson"
local meta = require "meta"
local no = meta.no
local ngx=ngx or {}

local options_pretty = {pretty=true, sort_keys=true, empty_table_as_array=true}
local options_sort = {sort_keys=true, empty_table_as_array=true}

local getmetatable = debug.getmetatable or getmetatable

local atom = {
  ["number"]=true,
  ["boolean"]=true,
}

local function clear(self)
  if type(self)~='table' then return self end
  setmetatable(self, nil)
  for k,v in pairs(self) do clear(v) end
  return self
end

local function __json(x)
  local to = (getmetatable(x or {}) or {}).__tojson
  if type(to)=='function' then return to(x) end
end

local function __string(x)
  local to = (getmetatable(x or {}) or {}).__tostring
  if type(to)=='function' then return to(x) end
end

local json = setmetatable({
  pretty=function(x) return jsonlib.encode(x, options_pretty) end,
  encode=function(x)
    if type(x)=='string' then return x end
    if type(x)~='table' and type(x)~='userdata' then return jsonlib.encode(x, options_sort) end
    return assert(jsonlib.encode(clear(x), options_sort))
  end,
  decode=function(x) return clear(jsonlib.decode(x)) end,
},{
  __call=function(self, x, deep)
    if atom[type(x)] and not deep then return self.encode(x) end
    if type(x)=='number' then return x end
    if type(x)=='boolean' then return x end
    if type(x)=='string' then return x end
    if type(x)=='nil' then return 'null' end
    if type(x)=='function' then return nil end
    if type(x)=='thread' then return nil end
    if type(x)=='userdata' then
      if type((getmetatable(x or {}) or {}).__tojson)=='function' then
        x=__json(x) --or __string(x)
        if deep then return x end
        return type(x)=='string' and x or self.encode(x)
      end
      return 'userdata'
    end
    if type(x)=='table' then
      if type((getmetatable(x or {}) or {}).__tojson)=='function' then
        x=__json(x)
        if deep then return x end
        return self.encode(x)
      end
      for k,v in pairs(x) do x[k]=self(v, true) end
      if deep then return x end
      return self.encode(x)
    end -- just convert
    error('unknownn type' .. type(x))
  end,
})

tojson = json

return json
