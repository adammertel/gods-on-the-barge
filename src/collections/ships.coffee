define 'Ships', ['Base', 'Collection', 'Ship'], (Base, Collection, Ship) ->
  class Nodes extends Collection
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

    createShip: (cult) ->
      if app.game.freeShips(cult) > 0
        app.game.shipBuilt(cult)
        @addGeometry new Ship(cult)
      return

    destroyShip: (ship) ->
      app.game.shipRemoved(ship.cult)
      @unregisterGeometry ship.id
      return

    registerGeometries: () ->
      return
