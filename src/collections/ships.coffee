define 'Ships', ['Base', 'Collection', 'Ship'], (Base, Collection, Ship) ->
  class Ships extends Collection
    constructor: (data) ->
      @name = 'ships'
      super()
      app.registerNewDayAction @updateEnergyForShips.bind @
      return

    findClosePorts: (ship) ->
      allPorts = app.getCollection('nodes').ports
      ports = []
      for port in allPorts
        ports.push {'id': parseInt(port), 'distance': app.getDistanceOfNodes ship.stops[0], port}
      _.orderBy ports, 'distance'

    findClosestPort: (ship) ->
      @findClosePorts(ship)[0].id

    stopToRest: (ship) ->
      if (ship.nextDistance/1000) / ship.energy < 2000
        @findClosePorts(ship)
      else
        return

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
