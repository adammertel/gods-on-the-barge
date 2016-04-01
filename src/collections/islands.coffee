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


    distanceCoefficient: (distance, maxDistance) ->
      1 - (distance / maxDistance)

    hungryCoefficient: (island) ->
      1 - island.state.grain / island.state.maxGrain

    attractivityCoefficient: (island) ->
      attractivity = if island.state.buildings.amphiteater then 0.2 else 0
      density = island.state.population/island.state.area

      # 2000~ is a density of Delos
      densityCoefficient = (density / 2000) * 0.5
      0.3 + attractivity + densityCoefficient

    tradeAttractivity: (distance, maxDistance, islandName) ->
      island = @getIslandByName(islandName)
      @distanceCoefficient(distance, maxDistance) * @hungryCoefficient(island) * @attractivityCoefficient(island)

    starvingPeople: ->
      for island in @geometries
        if island.state.starving > 0
          diedFromStarving = Math.ceil app.game.state.islands.starvingDeathRate * island.state.starving
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
        else
          island.state.starving = 0

      return

    missingGrain: (island) ->
      island.state.maxGrain - island.state.grain

    populationGrow: ->
      for island in @geometries
        if island.state.starving == 0
          growth = Base.round app.game.state.islands.growth * island.state.population
          island.state.population += growth
      return

    harvest: ->
      config = app.game.state.islands
      if app.time.state.season == Season[1] or app.time.state.season == Season[3]
        for island in @geometries
          rainfall = island.state.rainfall

          if rainfall > config.idealRainfallMin and rainfall < config.idealRainfallMax
            rainfallCoefficient = 1
          else if rainfall > config.criticalRainfallMax or rainfall < config.criticalRainfallMin
            rainfallCoefficient = 0.1
          else if rainfall < config.idealRainfallMin
            rainfallCoefficient = rainfall/config.idealRainfallMin - 0.1
          else if rainfall > config.idealRainfallMax
            rainfallCoefficient = config.idealRainfallMax/rainfall - 0.1
          console.log rainfallCoefficient, island.state.name

          harvested = Base.round(island.state.area * config.productionPerArea * 26 * rainfallCoefficient)
          island.state.harvestHistory.push harvested
          @addGrainToIsland island, harvested
          island.state.rainfall = 0
      return

    addGrainToIsland: (island, quantity) ->
      island.state.grain = _.clamp(island.state.grain + +quantity, 0, island.state.maxGrain)
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
        labelH = 25

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
        app.ctx.lineWidth = 1
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
