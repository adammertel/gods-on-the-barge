define 'Ship', ['Geometry', 'Base', 'Colors'], (Geometry, Base, Colors) ->
  class Ship extends Geometry
    constructor: (@cult, @startId = 1)->
      @collection = app.getCollection('ships')
      @cultStats = app.game.getCultStats(@cult).ships
      @endId = app.getCollection('nodes').chooseShipEndingNodeId()
      @checkPointIds = []
      @props = {
        minZoom: 0.4
      }
      @rotation = 0

      @color = app.game.state.cults[@cult].color
      @calculateStops()
      @coords = app.getCollection('nodes').nodeMapCoordinates @startId
      @rotation = @calculateRotation()

      @baseSpeed = @cultStats.baseSpeed

      @fullCargo = @cultStats.maxCargo
      @cargo = @fullCargo

      @restingSpeed = @cultStats.restingSpeed
      @fullEnergy = @cultStats.maxEnergy
      @energyConsumption = @cultStats.energyConsumption
      @energy = @fullEnergy

      @resting = false
      @willRest = false
      return

    addCheckPoint: (id) ->
      if _.indexOf(@checkPointIds, id) == -1
        @checkPointIds.unshift id
        @recalculateStops()
      return

    calculateStops: ->
      @stops = app.getPath @startId, @endId
      #@nextDistance = @calculateNextDistance()
      @nextStop = app.getCollection('nodes').nodeMapCoordinates @stops[0]
      return

    recalculateStops: ->
      from = @stops[0]
      @stops = app.getPathWithCheckPoints(@stops[0], @endId, @checkPointIds)
      @stops.unshift from
      return

    calculateNextDistance: ->
      app.getDistanceOfNodes(@stops[0], @stops[1])

    needRestCondition: ->
      @energy/@fullEnergy < 0.5

    move: ->
      if @resting
        if @energy == @fullEnergy
          @resting = false
          @willRest = false
      else
        if @energy < 0
          @collection.destroyShip(@)
        @checkNodeConflict()
        @coords = Base.moveTo @coords, @nextStop, @getSpeed()
      return

    updateEnergy: ->
      if @resting
        @energy += @restingSpeed
        @energy = _.clamp @energy, @fullEnergy
      else
        @energy -= @energyConsumption
      return

    prepareNextStop: ->
      @stops = _.slice @stops, 1
      @nextStop = app.getCollection('nodes').nodeMapCoordinates @stops[0]
      @rotation = @calculateRotation()

    checkNodeConflict: ->
      if app.getCollection('nodes').checkConflict @stops[0], @coords

        if @stops.length > 1
          _.pull @checkPointIds, @stops[0] # removes checkpoint

          if app.getCollection('nodes').isNodePort @stops[0]
            @resting = true
            @willRest = false
          else
          # sending ship to fill energy to the nearest port
            if !@willRest
              if @needRestCondition()
                @willRest = true
                @addCheckPoint @collection.findClosestPort(@)
              else
                tradeNode = @collection.getPlaceForTrade(@)
                if tradeNode
                  @willRest = true
                  @addCheckPoint tradeNode


          @prepareNextStop()

          #@nextDistance = @calculateNextDistance()
          return
        else # ship
          @collection.destroyShip(@)
          return
      else
        return

    calculateRotation: ->
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

    getSpeed: ->
      rainPenalty = if @collection.isInRain(@) then 1 - @cultStats.rainPenalty else 1

      @baseSpeed * app.time.state.timeSpeed * rainPenalty

    drawCargoBar: ->
      app.ctx.fillStyle = 'orange'
      fullCargopx = 40 * app.state.zoom
      cargopx = (fullCargopx / @fullCargo) * @cargo
      app.ctx.strokeRect @shipCoord.x - fullCargopx/2, @shipCoord.y - fullCargopx/2, fullCargopx, 3
      app.ctx.fillRect @shipCoord.x - fullCargopx/2, @shipCoord.y - fullCargopx/2, cargopx, 3
      return

    drawEnergyBar: ->
      app.ctx.fillStyle = 'blue'
      fullEnergypx = 40 * app.state.zoom
      energypx = (fullEnergypx / @fullEnergy) * @energy
      app.ctx.strokeRect @shipCoord.x - fullEnergypx/2, @shipCoord.y - fullEnergypx/2 - 6, fullEnergypx, 3
      app.ctx.fillRect @shipCoord.x - fullEnergypx/2, @shipCoord.y - fullEnergypx/2 - 6, energypx, 3
      return

    draw: ->

      @shipCoord = app.coordinateToView @coords
      @move()
      app.ctx.strokeStyle = 'black'
      app.ctx.lineWidth = 2
      @drawEnergyBar()
      @drawCargoBar()
      app.drawShip @shipCoord, app.state.zoom, @rotation, @color
      return
