define 'Islands', ['Base', 'Collection', 'Island'], (Base, Collection, Island) ->
  class Islands extends Collection
    constructor: (data) ->
      @name = 'islands'
      super data
      return

    registerGeometries: () ->
      _.each @data, (island, i) =>
        coords = []
        _.each island.coordinates[0], (coord, c) ->
          coords.push app.coordinateToMap {lon: coord[0], lat: coord[1]}
        @addGeometry new Island(coords, island)
      return
