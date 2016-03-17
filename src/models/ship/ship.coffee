define 'Ship', ['Geometry', 'Base'], (Geometry, Base) ->
  class Ship extends Geometry
    constructor: ()->
      @collectionName = 'ships'
      @startId = app.getCollection('nodes').chooseShipStartingNodeId()
      @endId = app.getCollection('nodes').chooseShipEndingNodeId()
      @baseSpeed = 1
      super app.getCollection('nodes').nodeMapCoordinates(@startId), {w: 15, h: 40}, {minZoom: 0.4}
      @calculateStops()
      @fullEnergy = 2000
      @energy = @fullEnergy
      return

    calculateStops: () ->
      @stops = app.getPath @startId, @endId
      @stops.push parseInt @endId
      @nextStop = app.getCollection('nodes').nodeMapCoordinates @stops[0]
      @rotation = @calculateRotation()
      return

    move: () ->
      @energy -= .5
      if @energy < 0
        @suicide()
      if app.getCollection('nodes').checkConflict @stops[0], @coords
        if @stops.length > 1
          @stops = _.slice @stops, 1
          @nextStop = app.getCollection('nodes').nodeMapCoordinates @stops[0]
          @rotation = @calculateRotation()
        else
          @suicide()
      @coords = Base.moveTo @coords, @nextStop, @getSpeed()

    calculateRotation: () ->
      dy = @coords.y - @nextStop.y
      dx = @nextStop.x - @coords.x

      theta = Math.atan2(-dy, dx)
      if theta < 0
        theta += 2 * Math.PI
      if theta > 3/2 * Math.PI
        theta -= 3/2 * Math.PI
      else
        theta += Math.PI/2
      theta

    getSpeed: () ->
      @baseSpeed * app.state.game.time.timeSpeed

    drawEnergyBar: () ->
      fullEnergypx = 60
      energypx = (fullEnergypx / @fullEnergy) * @energy
      app.ctx.strokeStyle = 'black'
      app.ctx.fillStyle = 'red'
      app.ctx.strokeRect @shipCoord.x - 30, @shipCoord.y - 30, fullEnergypx, 5
      app.ctx.fillRect @shipCoord.x - 30, @shipCoord.y - 30, energypx, 5

    draw: () ->
      @shipCoord = app.coordinateToView @coords
      @move()
      @drawEnergyBar()
      super()
      #
      # app.ctx.fillStyle = 'blue'
      # app.ctx.beginPath()
      # app.ctx.arc(shipCoord.x, shipCoord.y, 10*app.state.zoom, 0, 2 * Math.PI, false)
      # app.ctx.fill()
      return

    suicide: () ->
      app.getCollection(@collectionName).unregisterGeometry @id
      return

    sprite: 'ship'
