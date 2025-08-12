local driver = require "rapidjson"
local t = require 't'
local is=t.is
local export=t.exporter

local clear=function(self) return export(self, false) end
local opt = {
  pretty = {pretty=true, sort_keys=true, empty_table_as_array=true},
  sort = {sort_keys=true, empty_table_as_array=true},
}

return setmetatable({
  null=driver.null,
  pretty=function(x) return driver.encode(x, opt.pretty) end,
  encode=function(x, options)
    if x==driver.null or type(x)=='nil' then return driver.null end
    return driver.encode(clear(x), options or opt.sort)
  end,
  decode=function(x) if type(x)=='string' then
    local rv=driver.decode(x)
    local __type = (getmetatable(rv or {}) or {}).__jsontype
    rv=clear(rv)
    return __type=='array' and t.array(rv) or rv
  end; return x end,
  test  = is.json,
},{
  __call=function(self, x) return self.encode(x) end,
  __mod=function(a, b)
    if type(b)=='string' then return is.json(b) and a or nil end
  end,
  __tostring=function(self) return 'json' end,
})