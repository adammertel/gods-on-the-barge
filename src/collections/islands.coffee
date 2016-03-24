define 'Islands', ['Base', 'Collection', 'Island'], (Base, Collection, Island) ->
  class Islands extends Collection
    constructor: (data) ->
      @name = 'islands'
      @color = '#777'
      super data
      return

    registerGeometries: () ->
      for islandName, island of @data
        coords = []
        if island.coordinates
          for coord, c in island.coordinates[0]
            coords.push app.coordinateToMap {lon: coord[0], lat: coord[1]}
          @addGeometry new Island(coords, island)
      return

    draw: () ->
      app.ctx.beginPath()
      app.ctx.fillStyle = @color
      for geometry in @geometries
        if geometry
          geometry.draw()
      app.ctx.fill()
      app.ctx.closePath()
      return
