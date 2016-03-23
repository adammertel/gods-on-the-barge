define 'Islands', ['Base', 'Collection', 'Island'], (Base, Collection, Island) ->
  class Islands extends Collection
    constructor: (data) ->
      @name = 'islands'
      super data
      return

    registerGeometries: () ->
      for islandName, island of @data
        coords = []
        if island.coordinates
          for coord, c in  island.coordinates[0]
            coords.push app.coordinateToMap {lon: coord[0], lat: coord[1]}
          @addGeometry new Island(coords, island)
      return
