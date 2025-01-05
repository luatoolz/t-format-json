describe("json", function()
  local t, json, is
  setup(function()
    t = require "t"
    is = t.is
    json = t.format.json
  end)
  it("load", function()
    assert.is_table(json)
    assert.is_table(getmetatable(json))
  end)
  it("is", function()
    assert.is_nil(is.json())
    assert.is_nil(is.json(''))
    assert.is_nil(is.json(' '))
    assert.is_nil(is.json('  '))
    assert.is_nil(is.json('   '))

    assert.is_nil(is.json('null'))
    assert.is_nil(is.json('7'))
    assert.is_nil(is.json('"7"'))

    assert.is_true(is.json('[]'))
    assert.is_true(is.json('{}'))
    assert.is_true(is.json(' {}'))
    assert.is_true(is.json('{} '))
    assert.is_true(is.json(' {} '))
    assert.is_true(is.json(' []'))
    assert.is_true(is.json('[] '))
    assert.is_true(is.json(' [] '))

    assert.is_true(is.json(" {\n} "))
    assert.is_true(is.json(" [\n] "))

    assert.is_true(is.json(" \n{\n}\n "))
    assert.is_true(is.json(" \n[\n]\n "))
  end)
  it("encode", function()
    assert.equal(json.null, json())
    assert.equal(json.null, json(nil))
    assert.equal(json.null, json(json.null))

    assert.equal('7', json(7))
    assert.equal('7.2', json(7.2))
    assert.equal('"7"', json("7"))

    assert.equal('""', json(""))

    assert.equal('true', json(true))
    assert.equal('false', json(false))

    assert.equal('[]', json({}))

    assert.equal('["x"]', json({"x"}))
    assert.equal('["x","y"]', json({"x", "y"}))
    assert.equal('["x","y","z"]', json({"x", "y", "z"}))

    assert.equal('[1]', json({1}))
    assert.equal('[1,2]', json({1, 2}))
    assert.equal('[1,2,3]', json({1, 2, 3}))

    assert.equal('{"a":1}', json({a=1}))
    assert.equal('{"a":1,"b":"2"}', json({a=1, b="2"}))
    assert.equal('{"a":1,"b":"2"}', json({b="2", a=1}))

    assert.equal('["2",1]', json(t.array {"2", 1}))
    assert.equal('["1","2"]', json(t.set {"2", "1"}))
  end)
  it("decode", function()
    assert.is_nil(json.decode(""))
    assert.equal(json.null, json.decode('null'))

    assert.equal(7, json.decode('7'))
    assert.equal(7.2, json.decode('7.2'))
    assert.equal(7, json.decode("7"))
    assert.equal('7', json.decode('"7"'))

    assert.equal(true, json.decode('true'))
    assert.equal(false, json.decode('false'))

    assert.same({}, json.decode('[]'))

    assert.same({"x"}, json.decode('["x"]'))
    assert.same({"x", "y"}, json.decode('["x","y"]'))
    assert.same({"x", "y", "z"}, json.decode('["x","y","z"]'))

    assert.same({1}, json.decode('[1]'))
    assert.same({1, 2}, json.decode('[1,2]'))
    assert.same({1, 2, 3}, json.decode('[1,2,3]'))

    assert.same({a=1}, json.decode('{"a":1}'))
    assert.same({a=1, b="2"}, json.decode('{"a":1,"b":"2"}'))
    assert.same({b="2", a=1}, json.decode('{"a":1,"b":"2"}'))

    local three = '[{"_id":"66ba9cdee46231517f065198","token":"95687c9a1a88dd2d552438573dd018748dfff0222c76f085515be2dc1db2afa7","role":"root"},' ..
                      '{"_id":"66ba9cdee46231517f065199","token":"46db395df332f18b437d572837d314e421804aaed0f229872ce7d8825d11ff9a","role":"traffer"},' ..
                      '{"_id":"66ba9cdee46231517f06519a","token":"60879afb54028243bb82726a5485819a8bbcacd1df738439bfdf06bc3ea628d0","role":"panel"}]'
    local t3 = json.decode(three)
    assert.is_not_nil(t3)
    assert.equal(3, #t3)
    assert.equal('traffer', t3[2].role)

    local json_obj = '{"done":true, "message":"some", "created":0}'
    assert.is_true(is.json(json_obj))
    assert.is_table(json.decode(json_obj))
  end)
  it("pretty", function()
    assert.equal('[]', json.pretty({}))
    assert.equal("[\n    1\n]", json.pretty({1}))
    assert.equal("[\n    1,\n    2\n]", json.pretty({1, 2}))

    assert.equal('{\n    "a": 1\n}', json.pretty({a=1}))
    assert.equal('{\n    "a": 1,\n    "b": "2"\n}', json.pretty({a=1, b="2"}))
  end)
  it("objects", function()
    assert.equal('[]', json({}))
    assert.equal("[1]", json({1}))
    assert.equal("[1,2]", json({1, 2}))
    assert.equal('{"a":1}', json({a=1}))
    assert.equal('{"a":1,"b":"2"}', json({a=1, b="2"}))

    assert.equal('[]', json(t.array({})))
    assert.equal('[1,2,3]', json(t.array({1, 2, 3})))

    assert.equal('[]', json(table({})))
    assert.equal('[1,2,3]', json(table({1, 2, 3})))

    assert.is_nil(getmetatable(json.decode('{"a":"yes","b":["one","two","three","four","five"]}')))
    assert.is_nil(getmetatable(json.decode('{"a":"yes","b":["one","two","three","four","five"]}').b))
  end)
end)