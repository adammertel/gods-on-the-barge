define 'Ships', ['Base', 'Collection', 'Ship'], (Base, Collection, Ship) ->
  class Nodes extends Collection
    constructor: (data) ->
      @name = 'ships'
      super()
      return

    createShip: () ->
      @addGeometry new Ship()
      return

    registerGeometries: () ->
      return
