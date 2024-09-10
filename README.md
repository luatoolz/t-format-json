# t.format.json: json object
Wrapper around `rapidjson` for `t` lib.
```lua
local t = require "t"
local json = t.format.json

json({a=2})
json.decode('{"a":2}')
```

## depends luarocks
- `t`
- `rapidjson`

## system depends
alpine:
- `lua-dev`

debian:
- `liblua-dev`

## test depends
- `busted`
- `luacheck`

## TODO
- maybe `cjson` and/or other common libs support
  - https://github.com/neoxic/lua-json
  - https://github.com/mpx/lua-cjson
