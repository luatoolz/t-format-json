local t=t or require "t"
local is=t.is
local export=t.exporter
local match=t.match
local driver = require "rapidjson"

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
    x=clear(x)
    if type(x)=='string' then return x end
    if is.atom(x) then return driver.encode(x, options or opt.sort) end
    return assert(driver.encode(x, options or opt.sort))
  end,
  decode=function(x)
    local rv=driver.decode(x)
    local __type = (getmetatable(rv or {}) or {}).__jsontype
    rv=clear(rv)
    return __type=='array' and t.array(rv) or rv
  end,
},{
  __call=function(self, x) return self.encode(x) end,
  __mod=function(self, it) return is.json(it) end,
  __tostring=function(self) return match.basename(t.type(self)) end,
})