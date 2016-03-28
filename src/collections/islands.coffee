define 'Islands', ['Base', 'Collection', 'Island', 'Buildings', 'Season'], (Base, Collection, Island, Buildings, Season) ->
  class Islands extends Collection
    constructor: (data) ->
      @name = 'islands'
      @color = '#777'

      super data

      app.registerNewWeekAction @starvingPeople.bind @
      app.registerNewWeekAction @feedPeople.bind @
      app.registerNewSeasonAction @populationGrow.bind @
      app.registerNewSeasonAction @harvest.bind @
      return

    starvingPeople: ->
      for island in @geometries
        if island.state.starving > 0
          diedFromStarving = Math.ceil app.game.state.islands.starvingDeathRate * island.state.starving
          console.log island.state.name, 'diedFromStarving', diedFromStarving
          island.state.starving = _.clamp(island.state.starving - diedFromStarving, 0, island.state.starving)
          island.state.population = _.clamp(island.state.population - diedFromStarving, 0, island.state.population)
      return

    feedPeople: ->
      for island in @geometries
        consumption = Base.round app.game.state.islands.citizenConsumption * island.state.population
        island.state.grain -= consumption

        # people not getting their food
        if island.state.grain < 0
          starvingChances = _.random 0.2, 0.8 # not everyone without food is starving
          proportionOfStarving = Base.round (Math.abs(island.state.grain) / consumption) * starvingChances
          console.log 'people starting to starve', island.state.name, proportionOfStarving
          island.state.starving = _.max([island.state.starving, proportionOfStarving * island.state.population])
          island.state.grain = 0

      return

    populationGrow: ->
      for island in @geometries
        if island.state.starving == 0
          growth = Base.round app.game.state.islands.growth * island.state.population
          island.state.population += growth
      return

    harvest: ->
      if app.time.state.season == Season[1] or app.time.state.season == Season[3]
        for island in @geometries
          harvested = Base.round(island.state.area * app.game.state.islands.productionPerArea * 26)
          island.state.harvestHistory.push harvested
          island.state.grain = _.clamp(island.state.grain + +harvested, 0, island.state.maxGrain)
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
        labelW = 80
        labelH = 30

        app.ctx.font = 'bold 9pt Calibri'
        app.ctx.globalAlpha = 0.7
        app.ctx.fillStyle = 'white'
        app.ctx.textAlign = 'center'

        for island in @geometries
          if island.isVisible
            app.ctx.beginPath()
            island.drawLabelBackground labelW, labelH
            app.ctx.closePath()
            app.ctx.fill()

        app.ctx.globalAlpha = 1
        app.ctx.fillStyle = 'black'
        for island in @geometries
          if island.isVisible
            island.drawLabel labelW, labelH

        app.ctx.strokeStyle = 'black'
        app.ctx.fillStyle = 'green'
        for island in @geometries
          if island.isVisible
            island.drawFoodIndicator labelW, labelH


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
