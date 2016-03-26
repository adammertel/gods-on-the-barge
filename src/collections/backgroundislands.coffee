define 'BackgroundIslands', ['Base', 'Collection', 'BackgroundIsland'], (Base, Collection, BackgroundIsland) ->
  class BackgroundIslands extends Collection
    constructor: (@data) ->
      @name = 'backgroundIslands'
      @geometries = []
      return

    registerGeometries: ->
      for island, i in @data
        coords = []
        for islandGeom in island
          for coord, c in islandGeom
            coords.push app.coordinateToMap {lon: coord[0], lat: coord[1]}
        @addGeometry new BackgroundIsland(coords)
      return

    draw: ->
      app.ctx.fillStyle = '#ccc'
      for island in @geometries
        app.ctx.beginPath()
        island.draw()
        app.ctx.closePath()
        app.ctx.fill()
