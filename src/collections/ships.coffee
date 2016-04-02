define 'Ships', ['Base', 'Collection', 'Ship'], (Base, Collection, Ship) ->
  class Ships extends Collection
    constructor: (data) ->
      @name = 'ships'
      super()
      app.registerNewDayAction @updateEnergyForShips.bind @
      app.registerNewDayAction @payForFleet.bind @
      return

    payForFleet: ->
      for ship in @geometries
        app.game.payOperationalCosts(ship)
      return

    findClosePorts: (ship) ->
      allPorts = app.getCollection('nodes').ports
      ports = []
      for port in allPorts
        ports.push {'id': parseInt(port), 'distance': app.getDistanceOfNodes(ship.stops[0], port)}
      _.orderBy ports, 'distance'

    findClosestPort: (ship) ->
      @findClosePorts(ship)[0].id

    stopToRest: (ship) ->
      if (ship.nextDistance/1000) / ship.energy < 2000
        @findClosePorts(ship)
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
      ports = @findClosePorts(ship)
      maxDistanceForTrading = app.game.maxTradingDistanceForCult(ship.cult)
      criticalCargo = app.game.state.trade.criticalCargo
      cargoCoefficient = if ship.cargo > criticalCargo then 1 else ship.cargo / criticalCargo

      tradePlaces = []

      for port in ports
        islandName = app.getCollection('nodes').getIslandOfPort(port.id)

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

      #console.log tradeNode
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
      @addGeometry new Ship(cult, startingPoint)

    destroyShip: (ship) ->
      app.game.shipRemoved(ship.cult)
      @unregisterGeometry ship.id
      return

    registerGeometries: ->
      return
