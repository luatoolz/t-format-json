local inspect=require "inspect"
local driver = require "rapidjson"
require "meta"
local t=t or require "t"
local is=t.is
local tex=t.exporter

local options_pretty = {pretty=true, sort_keys=true, empty_table_as_array=true}
local options_sort = {sort_keys=true, empty_table_as_array=true}

local getmetatable = debug.getmetatable or getmetatable
local setmetatable = debug.setmetatable or setmetatable

local function clear(self)
  if type(self)~='table' then return self end
  setmetatable(self, nil)
  for k,v in pairs(self) do clear(v) end
  return self
end

local json
json = setmetatable({
  null=driver.null,
  pretty=function(x) return driver.encode(x, options_pretty) end,
  encode=function(x)
    if type(x)=='string' then return x end
    if type(x)~='table' and type(x)~='userdata' then return driver.encode(x, options_sort) end
    return assert(driver.encode(clear(x), options_sort))
  end,
  decode=function(x) return clear(driver.decode(x)) end,
  mt=function(x) return getmetatable(x or {}) or {} end,
  array=function(x) return is.table(x) and (self.mt(x).__array or self.mt(x).__arraytype or next(x)=='nil' or type(x[1])~='nil') or false end,
},{
  __call=function(self, x)
    if x==self.null or type(x)=='nil' then return self.null end
    if is.string(x) then return x end
    if is.atom(x) then return assert(driver.encode(x)) end
    return assert(driver.encode(tex(x, fix), options_sort))
  end,
})

return json
