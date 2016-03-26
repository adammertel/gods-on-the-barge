define 'Islands', ['Base', 'Collection', 'Island', 'Buildings'], (Base, Collection, Island, Buildings) ->
  class Islands extends Collection
    constructor: (data) ->
      @name = 'islands'
      @color = '#777'
      super data
      return

    registerGeometries: ->
      for islandName, island of @data
        coords = []
        if island.coordinates
          for coord, c in island.coordinates[0]
            coords.push app.coordinateToMap {lon: coord[0], lat: coord[1]}
          @addGeometry new Island(coords, island)
      return

    deactivateIslands: ->
      for island in @geometries
        island.state.active = false
      return

    activateIsland: (island)->
      @deactivateIslands()
      island.state.active = true
      return

    activateIslandByName: (name) ->
      @deactivateIslands()
      @getIslandByName(name).state.active = true
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

    getActiveIsland: ->
      activeIsland = false
      for island in @geometries
        if island.state.active
          activeIsland = island
      activeIsland

    activeteIslandByClick: (island) ->
      @activateIsland(island)
      app.menu.changeActivePanel 'Islands'
      app.menu.getActivePanel().changeActiveIsland(island.state.name)
      return

    drawLabels: ->
      if app.state.zoom > 0.6
        app.ctx.font = 'bold 10pt Calibri'
        app.ctx.fillStyle = 'white'

        for island in @geometries
          if island.isVisible
            app.ctx.beginPath()
            island.drawLabelBackground()
            app.ctx.fill()
            app.ctx.closePath()


        app.ctx.textAlign = 'left'
        app.ctx.fillStyle = 'black'
        for island in @geometries
          if island.isVisible
            island.drawLabel()

    draw: ->
      app.ctx.fillStyle = @color

      for island in @geometries
        if island
          if app.isClickedMap()
            if island.mouseConflict()
              @activeteIslandByClick island

          app.ctx.beginPath()
          island.draw()
          app.ctx.closePath()
          app.ctx.fill()


      activeIsland = @getActiveIsland()
      if activeIsland
        activeIsland.highlight()
      return
