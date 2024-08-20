describe("json", function()
  local t, json, is
  setup(function()
    t = require "t"
    is = t.is
    json = require "t.format.json"
  end)
	it("load", function()
    assert.is_table(json)
    assert.is_table(getmetatable(json))
  end)
	it("is", function()
    assert.is_false(is.json())
    assert.is_false(is.json(''))
    assert.is_false(is.json(' '))
    assert.is_false(is.json('  '))
    assert.is_false(is.json('   '))

    assert.is_false(is.json('null'))
    assert.is_false(is.json('7'))
    assert.is_false(is.json('"7"'))

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
		assert.equal('7', json("7"))

		assert.equal('', json(""))

		assert.equal('true', json(true))
		assert.equal('false', json(false))

		assert.equal('[]', json({}))

		assert.equal('["x"]', json({"x"}))
		assert.equal('["x","y"]', json({"x", "y"}))
		assert.equal('["x","y","z"]', json({"x", "y", "z"}))

		assert.equal('[1]', json({1}))
		assert.equal('[1,2]', json({1,2}))
		assert.equal('[1,2,3]', json({1,2,3}))

    assert.equal('{"a":1}', json({a=1}))
    assert.equal('{"a":1,"b":"2"}', json({a=1,b="2"}))
    assert.equal('{"a":1,"b":"2"}', json({b="2",a=1}))

    assert.equal('["2",1]', json(t.array{"2",1}))
    assert.equal('["1","2"]', json(t.set{"2","1"}))
	end)
	it("decode", function()
		assert.is_nil(json.decode(""))
    assert.equal(json.null, json.decode('null'))

		assert.equal(7, json.decode('7'))
		assert.equal(7.2, json.decode('7.2'))
		assert.equal(7, json.decode("7"))

		assert.equal(true, json.decode('true'))
		assert.equal(false, json.decode('false'))

		assert.same({}, json.decode('[]'))

		assert.same({"x"}, json.decode('["x"]'))
		assert.same({"x", "y"}, json.decode('["x","y"]'))
		assert.same({"x", "y", "z"}, json.decode('["x","y","z"]'))

		assert.same({1}, json.decode('[1]'))
		assert.same({1,2}, json.decode('[1,2]'))
		assert.same({1,2,3}, json.decode('[1,2,3]'))

		assert.same({a=1}, json.decode('{"a":1}'))
		assert.same({a=1,b="2"}, json.decode('{"a":1,"b":"2"}'))
		assert.same({b="2",a=1}, json.decode('{"a":1,"b":"2"}'))
	end)
	it("pretty", function()
		assert.equal('[]', json.pretty({}))
		assert.equal("[\n    1\n]", json.pretty({1}))
		assert.equal("[\n    1,\n    2\n]", json.pretty({1,2}))

		assert.equal('{\n    "a": 1\n}', json.pretty({a=1}))
		assert.equal('{\n    "a": 1,\n    "b": "2"\n}', json.pretty({a=1,b="2"}))
	end)
	it("objects", function()
		assert.equal('[]', json({}))
		assert.equal("[1]", json({1}))
		assert.equal("[1,2]", json({1,2}))
		assert.equal('{"a":1}', json({a=1}))
		assert.equal('{"a":1,"b":"2"}', json({a=1,b="2"}))

		assert.equal('[]', json(t.array({})))
		assert.equal('[1,2,3]', json(t.array({1,2,3})))

		assert.equal('[]', json(table({})))
		assert.equal('[1,2,3]', json(table({1,2,3})))
	end)
end)
