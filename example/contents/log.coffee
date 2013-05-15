time = require './time'

el = null
module.exports = (message) ->
  el ?= document.getElementById 'log'
  msg = document.createTextNode "[#{ time() }] #{ message }\n"
  el.appendChild msg
