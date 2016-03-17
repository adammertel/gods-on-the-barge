define 'Ships', ['Base', 'Collection', 'Ship'], (Base, Collection, Ship) ->
  class Nodes extends Collection
    constructor: (data) ->
      @name = 'ships'
      super()
      return

    findClosePorts: (ship) ->
      allPorts = app.getCollection('nodes').ports
      ports = []
      _.each allPorts, (port, p) =>
        ports.push {'id': port, 'distance': app.getDistanceOfNodes ship.stops[0], port}
      console.log _.orderBy ports, 'distance'
      return


    stopToRest: (ship) ->
      if (ship.nextDistance/1000) / ship.energy < 2000
        findClosePorts

    createShip: () ->
      @addGeometry new Ship()
      return

    registerGeometries: () ->
      return
