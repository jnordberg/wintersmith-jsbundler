
class Node

  constructor: (@id, @item) ->
    @edges = []

  addEdge: (node) ->
    if node not in @edges
      @edges.push node

class Graph

  constructor: (@identify) ->
    ### *identify* is a function that identifies an item. should return
        a unique string value representing that item. ###
    @nodes = {}

  addItem: (item) ->
    id = @identify item
    @nodes[id] ?= new Node id, item
    return @nodes[id]

  addDependency: (item, dependency) ->
    ### add a *dependency* for *item* ###
    node = @nodeFor item
    node.addEdge @nodeFor dependency

  dependenciesFor: (item) ->
    ### return a list of items that *item* depends on ###
    node = @nodeFor item
    resolved = @resolveNode node
    resolved.splice resolved.indexOf(node), 1
    return resolved.map (node) -> node.item

  dependsOn: (item) ->
    ### return a list of items depending on *item* ###
    target = @nodeFor item
    return @reverseLookup(target).map (node) -> node.item

  ### private ###

  nodeFor: (item) ->
    @nodes[@identify(item)] or @addItem(item)

  resolveNode: (node, resolved=[], seen={}) ->
    seen[node.id] = true
    for edge in node.edges
      if edge not in resolved and edge.id not of seen
        @resolveNode edge, resolved, seen
    resolved.push node
    return resolved

  reverseLookup: (target) ->
    rv = []
    for id, node of @nodes
      continue if node is target
      if target in @resolveNode node
        rv.push node
    return rv

module.exports = {Graph}
