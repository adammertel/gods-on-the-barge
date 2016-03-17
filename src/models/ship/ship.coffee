define 'Ship', ['Geometry', 'Base'], (Geometry, Base) ->
  class Ship extends Geometry
    constructor: ()->
      @startId = app.getCollection('nodes').chooseShipStartingNodeId()
      @endId = app.getCollection('nodes').chooseShipEndingNodeId()
      @baseSpeed = 1
      super app.getCollection('nodes').nodeMapCoordinates(@startId), {w: 10, h: 30}, {minZoom: 0.4}
      @calculateStops()
      @fullCargo = 1000
      @cargo = @fullCargo
      @fullEnergy = 800
      @energy = @fullEnergy
      return

    getCollection: () ->
      app.getCollection('ships')

    calculateStops: () ->
      @stops = app.getPath @startId, @endId
      @stops.push parseInt @endId
      @nextDistance = @calculateNextDistance()
      @nextStop = app.getCollection('nodes').nodeMapCoordinates @stops[0]
      @rotation = @calculateRotation()
      return

    calculateNextDistance: () ->
      app.getDistanceOfNodes(@stops[0], @stops[1])

    move: () ->
      @energy -= .5
      if @energy < 0
        @suicide()
      @checkNodeConflict()
      @coords = Base.moveTo @coords, @nextStop, @getSpeed()

    checkNodeConflict: () ->
      if app.getCollection('nodes').checkConflict @stops[0], @coords
        if @stops.length > 1
          console.log @getCollection().findClosePorts(@)
          @nextDistance = @calculateNextDistance()
          #console.log @getCollection().stopToRest(@)

          @stops = _.slice @stops, 1
          @nextStop = app.getCollection('nodes').nodeMapCoordinates @stops[0]
          @rotation = @calculateRotation()
        else
          @suicide()

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

    drawCargoBar: () ->
      fullCargopx = 40 * app.state.zoom
      cargopx = (fullCargopx / @fullCargo) * @cargo
      app.ctx.strokeStyle = 'black'
      app.ctx.fillStyle = 'orange'
      app.ctx.strokeRect @shipCoord.x - fullCargopx/2, @shipCoord.y - fullCargopx/2, fullCargopx, 3
      app.ctx.fillRect @shipCoord.x - fullCargopx/2, @shipCoord.y - fullCargopx/2, cargopx, 3

    drawEnergyBar: () ->
      fullEnergypx = 40 * app.state.zoom
      energypx = (fullEnergypx / @fullEnergy) * @energy
      app.ctx.strokeStyle = 'black'
      app.ctx.fillStyle = 'blue'
      app.ctx.strokeRect @shipCoord.x - fullEnergypx/2, @shipCoord.y - fullEnergypx/2 - 6, fullEnergypx, 3
      app.ctx.fillRect @shipCoord.x - fullEnergypx/2, @shipCoord.y - fullEnergypx/2 - 6, energypx, 3

    draw: () ->
      @shipCoord = app.coordinateToView @coords
      @move()
      @drawEnergyBar()
      @drawCargoBar()
      super()
      return

    suicide: () ->
      @getCollection().unregisterGeometry @id
      return

    sprite: 'ship'
