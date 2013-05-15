vows = require 'vows'
assert = require 'assert'
wintersmith = require 'wintersmith'

suite = vows.describe 'Plugin'

suite.addBatch
  'wintersmith environment':
    topic: -> wintersmith './example/config.json'
    'loaded ok': (env) ->
      assert.instanceOf env, wintersmith.Environment
    'contents':
      topic: (env) -> env.load @callback
      'loaded ok': (result) ->
        assert.instanceOf result.contents, wintersmith.ContentTree
      'has plugin instances': (result) ->
        assert.instanceOf result.contents['main.coffee'], wintersmith.ContentPlugin
        assert.instanceOf result.contents['subdir']['periodic.js'], wintersmith.ContentPlugin
        assert.isArray result.contents._.scripts
        assert.lengthOf result.contents._.scripts, 4
      'script sources': (result) ->
        for item in result.contents._.scripts
          assert.isString item.source
          assert.isTrue item.source.length > 0
      'script dependencies': (result) ->
        for item in result.contents._.scripts
          assert.isArray item.deps
      'main.coffee dependencies':
        topic: (result, env) ->
          deps = result.contents['main.coffee'].deps.map (dep) ->
            env.relativeContentsPath(dep)
          deps.sort()
          return deps
        'should be correct': (deps) ->
          assert.deepEqual deps, ['foo.js', 'log.coffee', 'subdir/periodic.js', 'time.coffee']

suite.export module
