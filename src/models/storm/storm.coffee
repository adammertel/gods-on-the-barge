define 'Storm', ['Geography', 'Base'], (Geography, Base) ->
  class Storm extends Geography

    constructor: (@id)->
      @power = _.random(4, 8, false)
      @collection = app.getCollection 'storms'
      @coords = @collection.newStormCoordinates()
      super()
      return

    reducePower: () ->
      @power -= 1
      if @power < 1
        @collection.unregisterGeometry @id
      return

    moveStorm: ->
      distance = app.weather.state.config.stormSpeedCoefficient * app.weather.state.windSpeed
      @coords = Base.moveInDirection @coords, app.weather.state.windDirection, distance * app.time.state.timeSpeed
      return

    draw: ->
      if @power > 1
        @moveStorm()
        app.ctx.globalAlpha = 0.5
        stormCoord = app.coordinateToView @coords
        app.ctx.fillStyle = 'blue'
        radius = @power * app.weather.state.config.stormRadiusCoefficient

        app.ctx.beginPath()
        app.ctx.arc(stormCoord.x, stormCoord.y, radius*app.state.zoom, 0, 2 * Math.PI, false)
        app.ctx.fill()
        app.ctx.globalAlpha = 1

      return
