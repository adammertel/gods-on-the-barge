define 'Routes', ['Base', 'Collection', 'Route'], (Base, Collection, Route) ->
  class Routes extends Collection
    constructor: (data) ->
      console.log 'routes'
      @name = 'routes'
      super data
      return

    registerGeometries: () ->
      nodes = app.getCollection('nodes').data

      _.each _.keys(@data), (edge, e) =>
        fromTo = edge.split '-'
        fromNode = nodes[parseInt(fromTo[0])]
        toNode = nodes[parseInt(fromTo[1])]
        from = app.coordinateToMap {lon: fromNode.x, lat: fromNode.y}
        to = app.coordinateToMap {lon: toNode.x, lat: toNode.y}
        @addGeometry new Route from, to
      return

    getDistanceOfEdge: (from, to) ->
      alt1 = from + '-' + to
      alt2 = to + '-' + from
      distance = false

      if @data[alt1]
        distance = @data[alt1]
      else if @data[alt2]
        distance = @data[alt2]

      distance
