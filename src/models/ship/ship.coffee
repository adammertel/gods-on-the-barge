define 'Ship', ['Geometry', 'Base', 'Colors'], (Geometry, Base, Colors) ->
  class Ship extends Geometry
    constructor: (@cult, @ctx, @startId = 1)->
      @collection = app.getCollection('ships')
      @cultStats = app.game.getCultStats(@cult).ships
      @endId = app.getCollection('nodes').chooseShipEndingNodeId()
      @checkPointIds = []
      @props = {
        minZoom: 0.4
      }
      @rotation = 0

      @visitedNodes = []
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
      @willTrade = false
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

    validateCargoQuantity: (quantity) ->
      if @cargo > quantity
        quantity
      else
        @cargo

    unshipCargo: (quantity) ->
      @cargo -= quantity
      return

    prepareNextStop: ->
      @stops = _.slice @stops, 1
      @nextStop = app.getCollection('nodes').nodeMapCoordinates @stops[0]
      @rotation = @calculateRotation()

    checkNodeConflict: ->
      if app.getCollection('nodes').checkConflict @stops[0], @coords
        @visitedNodes.push(@stops[0])

        if @stops.length > 1
          _.pull @checkPointIds, @stops[0] # removes checkpoint

          if app.getCollection('nodes').isNodePort @stops[0]
            @resting = true
            @willRest = false
            if @willTrade
              @willTrade = false
              @collection.trade @, @stops[0]

          else
          # sending ship to fill energy to the nearest port
            if !@willRest and !@willTrade
              if @needRestCondition()
                @willRest = true
                @willTrade = true
                @addCheckPoint @collection.findClosestPort(@)
              else
                tradeNode = @collection.getPlaceForTrade(@)
                if tradeNode
                  @willRest = true
                  @willTrade = true
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
      @ctx.fillStyle = 'orange'
      fullCargopx = 40 * app.state.zoom
      cargopx = (fullCargopx / @fullCargo) * @cargo
      @ctx.strokeRect @shipCoord.x - fullCargopx/2, @shipCoord.y - fullCargopx/2, fullCargopx, 3
      @ctx.fillRect @shipCoord.x - fullCargopx/2, @shipCoord.y - fullCargopx/2, cargopx, 3
      return

    drawEnergyBar: ->
      @ctx.fillStyle = 'blue'
      fullEnergypx = 40 * app.state.zoom
      energypx = (fullEnergypx / @fullEnergy) * @energy
      @ctx.strokeRect @shipCoord.x - fullEnergypx/2, @shipCoord.y - fullEnergypx/2 - 6, fullEnergypx, 3
      @ctx.fillRect @shipCoord.x - fullEnergypx/2, @shipCoord.y - fullEnergypx/2 - 6, energypx, 3
      return

    draw: ->
      @shipCoord = app.coordinateToView @coords
      @move()
      @ctx.strokeStyle = 'black'
      @ctx.lineWidth = 2
      @drawEnergyBar()
      @drawCargoBar()
      app.drawShip @ctx, @shipCoord, app.state.zoom, @rotation, @color
      return
