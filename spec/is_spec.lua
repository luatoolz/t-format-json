describe("is", function()
  local t, is
  setup(function()
    t = require "t"
    is = t.is
  end)
  it("tojson", function()
    assert.is_false(is.tojson())
    assert.is_false(is.tojson(nil))
    assert.is_false(is.tojson(7))
    assert.is_false(is.tojson(""))
    assert.is_false(is.tojson({}))

    assert.is_true(is.tojson(setmetatable({}, {__toJSON=function(x) return "" end})))

    assert.not_tojson()

    assert.not_tojson(setmetatable({}, {}))
    assert.not_tojson(setmetatable({}, {__call=function(x) return "" end}))

    assert.tojson(setmetatable({}, {__toJSON=function(x) return "" end}))
    assert.tojson(setmetatable({}, {__tojson=function(x) return "" end}))
  end)
end)
