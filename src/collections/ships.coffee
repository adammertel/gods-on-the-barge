define 'Ships', ['Base', 'Collection', 'Ship'], (Base, Collection, Ship) ->
  class Ships extends Collection
    constructor: (data) ->
      @name = 'ships'
      super()
      app.registerNewDayAction @updateEnergyForShips.bind @
      app.registerNewDayAction @payForFleet.bind @
      return

    getShipsOfCult: (cult) ->
      cultShips = []
      for ship in @geometries
        if ship.cult == cult
          cultShips.push ship
      cultShips

    payForFleet: ->
      for ship in @geometries
        app.game.payOperationalCosts(ship)
      return

    findClosePorts: (ship, warExcluded) ->
      allPorts = app.getCollection('nodes').ports
      ports = []

      for port in allPorts
        if warExcluded
          islandName = app.getCollection('nodes').getIslandOfPort port
          island = app.getCollection('islands').getIslandByName islandName
          if island
            if island.state.event
              if island.state.event.name != 'war'
                ports.push {'id': parseInt(port), 'distance': app.getDistanceOfNodes(ship.stops[0], port)}
            else
                ports.push {'id': parseInt(port), 'distance': app.getDistanceOfNodes(ship.stops[0], port)}
        else
          ports.push {'id': parseInt(port), 'distance': app.getDistanceOfNodes(ship.stops[0], port)}

      _.orderBy ports, 'distance'

    findClosestPort: (ship) ->
      @findClosePorts(ship, true)[0].id

    stopToRest: (ship) ->
      if (ship.nextDistance/1000) / ship.energy < 2000
        @findClosePorts ship, true
      else
        return

    trade: (ship, portId) ->
      islandName = app.getCollection('nodes').getIslandOfPort(portId)
      if islandName != 'Turkey' and islandName != 'Greece' and islandName != 'Egypt'
        island =  app.getCollection('islands').getIslandByName islandName
        app.game.makeTrade ship, island
        app.game.makeConversion ship.cult, island, app.game.numberOfConverting ship.cult
      return

    getPlaceForTrade: (ship) ->
      ports = @findClosePorts ship, true
      maxDistanceForTrading = app.game.maxTradingDistanceForCult(ship.cult)
      criticalCargo = app.game.state.trade.criticalCargo
      cargoCoefficient = if ship.cargo > criticalCargo then 1 else ship.cargo / criticalCargo

      tradePlaces = []

      for port in ports
        islandName = app.getCollection('nodes').getIslandOfPort(port.id)

        # intersection of possible path to a new trade spot with visited places of that ship - ship is not supposed to visit one node more than once
        pathIntersection = _.intersection app.getPath(port.id, ship.stops[0]), ship.visitedNodes

        # the intersection is always at least with length of 1
        if pathIntersection.length == 1

          # filtering continental ports out
          if islandName != 'Turkey' and islandName != 'Greece' and islandName != 'Egypt'
            if port.distance < maxDistanceForTrading
              tradeCoefficient = app.getCollection('islands').tradeAttractivity(port.distance, maxDistanceForTrading, islandName, ship.cult)
              tradePlaces.push {'port': port, 'coefficient': tradeCoefficient * cargoCoefficient}

      tradeOrdered = _.orderBy(_.clone(tradePlaces), 'coefficient', 'desc').splice(0, 5)
      #console.log tradeOrdered

      tradeNode = false
      for tradePlace in tradeOrdered
        if !tradeNode
          if Math.random() < tradePlace.coefficient
            tradeNode = tradePlace.port.id

      tradeNode

    updateEnergyForShips: ->
      for ship in @geometries
        ship.updateEnergy()
      return

    isInRain: (ship) ->
      inRain = false
      for storm in app.getCollection('storms').geometries
        if Base.distance(storm.coords, ship.coords) < storm.radius
          inRain = true
      inRain

    createShip: (cult, startingPoint) ->
      @addGeometry new Ship(cult, @ctx, startingPoint)

    destroyShip: (ship) ->
      app.game.shipRemoved(ship.cult)
      @unregisterGeometry ship.id
      return

    registerGeometries: ->
      return
