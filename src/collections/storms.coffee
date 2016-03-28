define 'Storms', ['Base', 'Collection', 'Storm', 'Colors'], (Base, Collection, Storm, Colors) ->
  class Storms extends Collection
    constructor: ->
      @name = 'storms'
      super []
      return

    registerGeometries: ->
      return

    getNode: (id) ->
      @data[id]

    nodeMapCoordinates: (id) ->
      node = @getNode(id)
      try
        app.coordinateToMap {lon: node.x, lat: node.y}
      catch
        console.log 'node problem', node, 'id', id

    addGeometry: (storm) ->
      @geometries.push storm
      return

    reducePower: ->
      for storm in @geometries
        if storm
          storm.reducePower()
      return

    draw: ->
      app.ctx.fillStyle = Colors.STORMMAP
      for storm in @geometries
        storm.draw()
      return

    newStormCoordinates: ->
      windDirection = app.weather.state.windDirection
      x = false
      y = false

      # storm from the west
      if windDirection >= 45 and windDirection < 135
        x = 0
      # storm from the north
      else if windDirection >= 135 and windDirection < 225
        y = 0
      # storm from the east
      else if windDirection >= 225 and windDirection < 315
        x = app.state.map.w
      # storm from the south
      else
        y = app.state.map.h

      if x == false
        x = _.random(0, app.state.map.w, false)
      if y == false
        y = _.random(0, app.state.map.h, false)

      {x: x, y: y}
