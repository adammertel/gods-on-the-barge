define 'Nodes', ['Base', 'Collection', 'Port'], (Base, Collection, Port) ->
  class Nodes extends Collection
    constructor: (data) ->
      @name = 'nodes'
      super data
      return

    limitConflict: 10

    registerGeometries: () ->
      @ports = []
      _.each _.keys(@data), (nodeId, n) =>
        islandValue = @data[nodeId]
        if islandValue.island
          @ports.push nodeId
        @addGeometry new Port(app.coordinateToMap({lon: islandValue.x, lat: islandValue.y}), nodeId, islandValue.island)
        return
      return

    getNode: (id) ->
      @data[id]

    isNodePort: (id) ->
      @data[id].island?

    nodeMapCoordinates: (id) ->
      node = @getNode(id)
      app.coordinateToMap {lon: node.x, lat: node.y}

    checkConflict: (id, coords) ->
      Base.distance(@nodeMapCoordinates(id), coords) < @limitConflict * app.time.state.timeSpeed

    getIdOfNode: (node) ->
      id = false
      self = @
      _.each _.keys(@data), (nodeKey, k) ->
        if self.data[nodeKey].x == node.x
          id = nodeKey
        return
      id

    getNodesOnIsland: (islandName) ->
      _.filter @data, (node, n) ->
        node.island == islandName

    getAllPorts: () ->
      _.filter @data, (node, n) ->
        node.island != ''

    chooseShipStartingNodeId: () ->
      @getIdOfNode _.sample @getShipStartingNodes()

    chooseShipEndingNodeId: () ->
      @getIdOfNode _.sample @getShipEndingNodes()

    getShipStartingNodes: () ->
      @getNodesOnIsland 'Egypt'

    getShipEndingNodes: () ->
      _.union @getNodesOnIsland('Greece'), @getNodesOnIsland('Turkey')
