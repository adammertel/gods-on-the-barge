define 'BackgroundIslands', ['Base', 'Collection', 'BackgroundIsland', 'Colors'], (Base, Collection, BackgroundIsland, Colors) ->
  class BackgroundIslands extends Collection
    constructor: (data) ->
      @name = 'backgroundIslands'
      super data
      return

    registerGeometries: ->
      for island, i in @data
        coords = []
        for islandGeom in island
          for coord, c in islandGeom
            coords.push app.coordinateToMap {lon: coord[0], lat: coord[1]}
        @addGeometry new BackgroundIsland(coords, @ctx)
      return

    setStyle: ->
      @ctx.fillStyle = Colors.BCKISLANDMAP
      return

    draw: ->
      for island in @geometries
        @ctx.beginPath()
        island.draw()
        @ctx.closePath()
        @ctx.fill()
