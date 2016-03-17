define 'Nodes', ['Base', 'Collection', 'Port'], (Base, Collection, Port) ->
  class Nodes extends Collection
    constructor: (data) ->
      @name = 'nodes'
      super data
      return

    limitConflict: 10
    registerGeometries: () ->

      _.each _.keys(@data), (nodeId, n) =>
        #if node.island
          #@addGeometry new Port(app.coordinateToMap {lon: node.x, lat: node.y})
        islandValue = @data[nodeId]
        @addGeometry new Port(app.coordinateToMap({lon: islandValue.x, lat: islandValue.y}), nodeId, islandValue.island)
      return

    getNode: (id) ->
      @data[id]

    nodeMapCoordinates: (id) ->
      node = @getNode(id)
      app.coordinateToMap {lon: node.x, lat: node.y}

    checkConflict: (id, coords) ->
      Base.distance(@nodeMapCoordinates(id), coords) < @limitConflict

    getIdOfNode: (node) ->
      id = false
      _.each _.keys(@data), (nodeKey, k) =>
        if @data[nodeKey].x == node.x
          id = nodeKey
      id

    getNodesOnIsland: (islandName) ->
      _.filter @data, (node, n) ->
        node.island == islandName

    chooseShipStartingNodeId: () ->
      @getIdOfNode _.sample @getShipStartingNodes()

    chooseShipEndingNodeId: () ->
      @getIdOfNode _.sample @getShipEndingNodes()

    getShipStartingNodes: () ->
      @getNodesOnIsland 'Egypt'

    getShipEndingNodes: () ->
      _.union @getNodesOnIsland('Greece'), @getNodesOnIsland('Turkey')
