### Wintersmith plugin that bundles javascript
    and coffeescript modules for the browser ###

{bundle, traverseDependencies} = require 'commonjs-everywhere'
escodegen = require 'escodegen'
fs = require 'fs'
path = require 'path'
util = require 'util'
{Graph} = require './graph'

defaultFormat =
  indent:
    style: '  '
    base: 0
  renumber: yes
  hexadecimal: yes
  quotes: 'auto'
  parentheses: no

compactFormat =
  indent:
    style: ''
    base: 0
  renumber: yes
  hexadecimal: yes
  quotes: 'auto'
  escapeless: yes
  compact: yes
  parentheses: no
  semicolons: no

module.exports = (env, callback) ->
  options = env.config.bundler or {}
  options.minify ?= (env.mode is 'build')
  options.sourceMap ?= (env.mode is 'preview')

  cache =
    etags: {}
    processed: {}
    sources: {}
    deps: {}

  graph = new Graph (item) -> item

  loadInstance = (filepath) ->
    cache.etags[filepath.full] ?= {}
    processed = traverseDependencies filepath.full, env.contentsPath,
      cache: cache.etags[filepath.full]

    for file, value of processed
      if file is filepath.full
        graph.addItem filepath.full
      else
        graph.addDependency filepath.full, file
      cache.processed[file] = value
      cache.sources['/'+env.relativeContentsPath(file)] = fs.readFileSync(file).toString()

    return new ScriptBundler filepath

  class ScriptBundler extends env.ContentPlugin

    constructor: (@filepath) ->

    @property 'source', ->
      cache.sources["/#{ @filepath.relative }"]

    @property 'deps', ->
      graph.dependenciesFor @filepath.full

    getFilename: ->
      @filepath.relative.replace /\.coffee$/, '.js'

    getView: -> (env, locals, contents, templates, callback) ->
      opts =
        comment: !options.minify
        format: if options.minify then compactFormat else defaultFormat

      if options.sourceMap
        opts.sourceMap = true
        opts.sourceMapWithCode = true
        opts.sourceMapRoot = path.dirname(@filepath.relative) or '.'

      processed = {}
      processed[@filepath.full] = cache.processed[@filepath.full]
      for file in @deps
        processed[file] = cache.processed[file]

      try
        bundled = bundle processed, @filepath.full, env.contentsPath, {}
      catch error
        callback error
        return

      if options.sourceMap
        {code, map} = escodegen.generate bundled, opts

        map = map.toJSON()
        map.sourcesContent = map.sources.map (name) -> cache.sources[name]
        map = new Buffer(JSON.stringify(map)).toString('base64')

        code = """
          //@ sourceMappingURL=data:application/json;base64,#{ map }
          #{ code }
        """
      else
        code = escodegen.generate bundled, opts

      callback null, new Buffer(code)

    getPluginColor: -> 'magenta'
    getPluginInfo: ->
      deps = @deps.map (dep) -> env.relativeContentsPath dep
      if deps.length
        "#{ super() } deps: #{ deps.sort().join(' ') }"
      else
        super()

  ScriptBundler.fromFile = (filepath, callback) ->
    try
      instance = loadInstance filepath
    catch error
      cache.etags[filepath.full] = {}
    callback error, instance

  env.registerContentPlugin 'scripts', '**/*.*(js|coffee)', ScriptBundler
  callback()
