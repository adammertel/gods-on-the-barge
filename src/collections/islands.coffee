define 'Islands', ['Base', 'Collection', 'Island', 'Buildings'], (Base, Collection, Island, Buildings) ->
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

    getIslandByName: (name) ->
      _.find @geometries, (island) ->
        island.data.name == name

    hasIslandBuilding: (islandName, building) ->
      island = @getIslandByName islandName
      island.state.buildings[building]

    build: (cult, islandName, buildingLabel) ->
      if !@hasIslandBuilding(islandName, buildingLabel)
        building = _.find(_.values(Buildings), {'name':buildingLabel})

        if app.game.spendGold cult, building.price
          island = @getIslandByName islandName
          island.state.buildings[building.name] = true
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
