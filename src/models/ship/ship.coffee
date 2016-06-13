define 'Ship', ['Geometry', 'Base', 'Colors'], (Geometry, Base, Colors) ->
  class Ship extends Geometry
    constructor: (@cult, @ctx, @startId = 1)->
      @props = {
        minZoom: 0.4
      }

      @collection = app.getCollection('ships')
      @cultStats = app.game.getCultStats(@cult).ships
      @endId = app.getCollection('nodes').chooseShipEndingNodeId()
      @checkPointIds = []
      @visitedNodes = []

      @stops = app.getPath @startId, @endId
      @nextStop = app.getCollection('nodes').nodeMapCoordinates @stops[0]
      @remainingDistance = @getEdgeDistance @startId, @stops[0]

      @coords = app.getCollection('nodes').nodeMapCoordinates @startId

      @rotation = @calculateRotation()

      @baseSpeed = @cultStats.baseSpeed

      @fullCargo = @cultStats.maxCargo
      @cargo = @fullCargo

      @restingSpeed = @cultStats.restingSpeed
      @fullEnergy = @cultStats.maxEnergy
      @energyConsumption = @cultStats.energyConsumption
      @energy = @fullEnergy

      @inPort = false
      @willPort= false
      return

    getEdgeDistance: (fromId, toId)->
      from = app.getCollection('nodes').nodeMapCoordinates fromId
      to = app.getCollection('nodes').nodeMapCoordinates toId
      #app.getDistanceOfNodes(@stops[0], @stops[1]) / app.state.pxkm
      Base.distance(from, to)# / app.state.pxkm

    validateCargoQuantity: (quantity) ->
      if @cargo > quantity
        quantity
      else
        @cargo

    unshipCargo: (quantity) ->
      @cargo -= quantity
      return

    addCheckPoint: (id) ->
      if _.indexOf(@checkPointIds, id) == -1
        @checkPointIds.unshift id
      return

    recalculateStops: ->
      from = @stops[0]
      @stops = app.getPathWithCheckPoints(@stops[0], @endId, @checkPointIds)
      @stops.unshift from
      return

    getNextStop: ->
      @remainingDistance = @getEdgeDistance @stops[0], @stops[1]
      @stops = _.slice @stops, 1
      @nextStop = app.getCollection('nodes').nodeMapCoordinates @stops[0]
      @rotation = @calculateRotation()
      return

    findTrade: ->
      newTradeNode = @collection.getPlaceForTrade(@)
      console.log 'newTradeNode', newTradeNode
      if newTradeNode
        @addCheckPoint newTradeNode
        @recalculateStops()
      return

    findRest: ->
      @addCheckPoint @collection.findClosestPort @, false
      @recalculateStops()
      return

    cruisedDistance: ->
      rainPenalty = if @collection.isInRain(@) then 1 - @cultStats.rainPenalty else 1
      @baseSpeed * app.time.state.timeSpeed * rainPenalty * app.state.pxkm

    needRestCondition: ->
      @energy/@fullEnergy < 0.5

    movedCoordinates: (distance) ->
      Base.moveTo @coords, @nextStop, distance

    updateEnergy: ->
      if @inPort
        @energy = _.clamp @energy + @restingSpeed, @fullEnergy
      else
        @energy -= @energyConsumption
      return

    checkNodeConflict: ->
      @remainingDistance < 0

    draw: ->
      @shipCoord = app.coordinateToView(@coords)

      if @energy < 0
        @collection.destroyShip(@)

      else
        if @inPort
          if @energy == @fullEnergy
            @inPort = false
            @willPort = false

        else
          cruisedDistance = @cruisedDistance()
          @remainingDistance -= cruisedDistance
          @coords = @movedCoordinates cruisedDistance

          # hits node?
          if @checkNodeConflict()
            @visitedNodes.push @stops[0]
            # there is at least one node to visit
            if @stops.length > 1
              _.pull @checkPointIds, @stops[0] # removes checkpoint

              # ship in port
              if app.getCollection('nodes').isNodePort @stops[0]
                @collection.trade @, @stops[0]
                @inPort = true
                @willPort = false

              # ship in non-port node
              else if !@willPort
                @findTrade()

              # getting new stop
              @getNextStop()

            # no remaining stops
            else
              @collection.destroyShip(@)

          # check rest conditions
          if !@willPort and !@inPort and @needRestCondition()
            @willPort = true
            @findRest()


      # own drawing
      @ctx.strokeStyle = 'black'
      @ctx.lineWidth = 2
      @color = app.game.state.cults[@cult].color
      @drawEnergyBar()
      @drawCargoBar()
      app.drawShip @ctx, @shipCoord, app.state.zoom, @rotation, @color
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

    drawCargoBar: ->
      @ctx.fillStyle = Colors.SHIPCARGOINDICATOR
      fullCargopx = 40 * app.state.zoom
      cargopx = (fullCargopx / @fullCargo) * @cargo
      @ctx.strokeRect @shipCoord.x - fullCargopx/2, @shipCoord.y - fullCargopx/2, fullCargopx, 3
      @ctx.fillRect @shipCoord.x - fullCargopx/2, @shipCoord.y - fullCargopx/2, cargopx, 3
      return

    drawEnergyBar: ->
      @ctx.fillStyle = Colors.SHIPENERGYINDICATOR
      fullEnergypx = 40 * app.state.zoom
      energypx = (fullEnergypx / @fullEnergy) * @energy
      @ctx.strokeRect @shipCoord.x - fullEnergypx/2, @shipCoord.y - fullEnergypx/2 - 6, fullEnergypx, 3
      @ctx.fillRect @shipCoord.x - fullEnergypx/2, @shipCoord.y - fullEnergypx/2 - 6, energypx, 3
      return
