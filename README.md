# t.format.json: json object
```lua
local t = require "t"
local json = t.format.json

_ = json.encode({a=2})
_ = json.pretty({a=2})

_ = json.decode('{"a":2}')
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
