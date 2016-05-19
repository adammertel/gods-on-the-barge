define 'Storm', ['Geography', 'Colors', 'Base'], (Geography, Colors, Base) ->
  class Storm extends Geography

    constructor: (@id, @ctx)->
      @power = _.random(4, 8, false)
      @collection = app.getCollection 'storms'
      @coords = @collection.newStormCoordinates()
      super()
      return

    reducePower: ->
      @power -= _.random 0, 0.2
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
        @ctx.globalAlpha = 0.3
        stormCoord = app.coordinateToView @coords
        @radius = @power * app.weather.state.config.stormRadiusCoefficient

        @ctx.beginPath()
        @ctx.arc(stormCoord.x, stormCoord.y, @radius*app.state.zoom, 0, 2 * Math.PI, false)
        @ctx.closePath()
        @ctx.fill()

        @ctx.globalAlpha = 1


      return
