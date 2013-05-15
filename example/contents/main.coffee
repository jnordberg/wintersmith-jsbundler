foo = require './foo'
log = require './log'
periodic = require './subdir/periodic'

main = ->
  log 'I can have green tea?'
  foo 'tea'
  periodic "hello there", log

window.addEventListener 'DOMContentLoaded', main, false
