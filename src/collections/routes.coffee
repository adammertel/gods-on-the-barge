define 'Routes', ['Base', 'Collection', 'Route', 'Colors'], (Base, Collection, Route, Colors) ->
  class Routes extends Collection
    constructor: (data) ->
      @name = 'routes'
      super data
      return

    registerGeometries: ->
      nodes = app.getCollection('nodes').data

      _.each _.keys(@data), (edge, e) =>
        fromTo = edge.split '-'
        fromNode = nodes[parseInt(fromTo[0])]
        toNode = nodes[parseInt(fromTo[1])]
        from = app.coordinateToMap {lon: fromNode.x, lat: fromNode.y}
        to = app.coordinateToMap {lon: toNode.x, lat: toNode.y}
        @addGeometry new Route from, to
      return

    setStyle: ->
      @ctx.strokeStyle = Colors.ROUTEMAP
      @ctx.lineWidth = 1

    getDistanceOfEdge: (from, to) ->
      alt1 = from + '-' + to
      alt2 = to + '-' + from
      distance = false

      if @data[alt1]
        distance = @data[alt1]
      else if @data[alt2]
        distance = @data[alt2]

      distance

    draw: ->
      routes = []
      for route in @geometries
        fromView = app.coordinateToView route.from
        toView = app.coordinateToView route.to
        path = "M " + fromView.x + " " + fromView.y + " L " + toView.x + " " + toView.y
        routes.push path

      @ctx.stroke new Path2D routes.join ' '

      return
