define 'Game', ['Base', 'Colors'], (Base, Colors) ->
  class Game
    state:
      politics:
        endingPoints: {}
      player:
        cult: ''
      islands:
        citizenConsumption: 0.02
        productionPerArea: 0.7
        growth: 0.01
        starvingDeathRate: 0.05
        idealRainfallMin: 500
        idealRainfallMin: 800
        criticalRainfallMin: 100
        criticalRainfallMax: 1200
      trade:
        maxBaseDistanceForTrade: 50000
        criticalCargo: 500
        baseGrainPrice: 0.0001
      ships:
        buildCost0: 100
        buildCost1: 100
        baseBuildCost: 100
        buildCostVariability: 0.3
        buildCostTemperatureSignificance: 0.1
      cults:
        'Serapis':
          no: 1
          label: 'Serapis'
          iconLabel: 'serapis'
          color: Colors.CULTSERAPIS
          text: 'Serapis was a god of blablabla'
          stats:
            ships:
              maxEnergy: 500
        'Isis':
          no: 2
          iconLabel: 'isis'
          label: 'Isis'
          color: Colors.CULTISIS
          text: 'Isis was a goddess of something else and blablabla...'
          stats:
            ships:
              maxCargo: 500000
        'Anubis':
          no: 3
          iconLabel: 'anubis'
          label: 'Anubis'
          color: Colors.CULTANUBIS
          text: 'And also Anubis was here. He was a blablabla...'
          stats:
            ships:
              operationCost: 0.8
        'Bastet':
          no: 4
          iconLabel: 'bastet'
          label: 'Bastet'
          color: Colors.CULTBASTET
          text: 'Bastet is the last one here but not blablabla...'
          stats: {}

    defaultCultStats:
      gold:
        quantity: 1000
      politics:
        pointRegeneration: 1
        freePoints: 2
        maxFreePoints: 3
      ships:
        no: 7
        out: 0
        baseSpeed: 1
        maxCargo: 500000
        maxEnergy: 400
        energyConsumption: 40
        restingSpeed: 120
        operationCost: 1
        rainPenalty: 0.3
      trade:
        tradingDistanceCoefficient: 1
        tradeEffectivity: 1

    constructor: ->
      @loadIcons()
      @loadStats()
      @loadPolitics()
      app.registerNewDayAction @calculateBuildCost.bind @
      app.registerNewWeekAction @randomPolitics.bind @
      app.registerNewSeasonAction @addNewPoliticsPoints.bind @

    loadStats: ->
      _.each @state.cults, (cult, cultLabel) =>
        defaultCultStats = _.clone(@defaultCultStats)
        cultStats = _.clone(cult.stats)
        @state.cults[cultLabel].stats = _.merge({}, defaultCultStats, cultStats)
        return
      return

    loadIcons: ->
      _.each @state.cults, (cult, cultLabel) =>
        cult.logo = Base.loadIcon cult.iconLabel, cult.color
        return
      return


    # TRADING
    maxTradingDistanceForCult: (cult) ->
      console.log cult
      @getStat(cult, 'trade', 'tradingDistanceCoefficient') * @state.trade.maxBaseDistanceForTrade

    makeTrade: (ship, islandName) ->
      cult = ship.cult
      grain = ship.cargo

      islandsCollection = app.getCollection('islands')
      island = islandsCollection.getIslandByName islandName

      quantityCoefficient = islandsCollection.hungryCoefficient(island) * Math.random()
      quantity = ship.validateCargoQuantity(quantityCoefficient * islandsCollection.missingGrain(island))

      console.log 'will trade, ' , quantity
      islandsCollection.addGrainToIsland island, quantity
      ship.unshipCargo quantity

      totalPrice = quantity * @getStat(cult, 'trade', 'tradeEffectivity')
      @earnGold cult, totalPrice
      return


    # POLITICS
    # initial action for loading all ending points for ships
    loadPolitics: ->
      @endingPoints = app.getCollection('nodes').getShipEndingNodes()
      for endNode in @endingPoints
        nodeId = app.getCollection('nodes').getIdOfNode endNode
        @state.politics.endingPoints[nodeId] = 5

      return

    # adding new points to make politics each year
    addNewPoliticsPoints: ->
      for c, cult of @state.cults
        politicsStats = cult.stats.politics
        politicsStats.freePoints = _.clamp politicsStats.freePoints + politicsStats.pointRegeneration, 0, politicsStats.maxFreePoints

    # moving some random points every week
    randomPolitics: ->
      nodes = app.getCollection('nodes')
      game = @

      lowerRandomPoint = ->
        randomEndingPointToLower = nodes.getIdOfNode _.sample(nodes.getShipEndingNodes())
        game.lowerEndingPoint randomEndingPointToLower

      raiseRandomPoint = ->
        randomEndingPointToRaise = nodes.getIdOfNode _.sample(nodes.getShipEndingNodes())
        game.raiseEndingPoint randomEndingPointToRaise

      lowerRandomPoint()
      lowerRandomPoint()
      lowerRandomPoint()
      raiseRandomPoint()

      return

    raiseEndingPoint: (endingPointId) ->
      if @state.politics.endingPoints[endingPointId] < 10
        @state.politics.endingPoints[endingPointId] += 1
        true
      else
        false

    lowerEndingPoint: (endingPointId) ->
      if @state.politics.endingPoints[endingPointId] != 0
        @state.politics.endingPoints[endingPointId] -= 1
        true
      else
        false

    voteForEndingPoint: (cult, endingPointId) ->
      if @getCultPoliticsPoints(cult) > 0
        if @raiseEndingPoint(endingPointId)
          @spendPoliticsPoint cult
        true
      else
        false

    playerVoteForEndingPoint: (endingPointId) ->
      @voteForEndingPoint @getPlayerCultLabel(), endingPointId

    spendPoliticsPoint: (cult) ->
      if @getCultPoliticsPoints(cult) > 0
        @getCultStats(cult).politics.freePoints -= 1
      return



    # SHIPS
    createShip: (cult, portId) ->
      if @freeShips(cult) > 0 and @hasCultGoldToBuildShip cult, portId
        @shipBuilt(cult, portId)
        app.getCollection('ships').createShip cult, portId
      return

    shipRemoved: (cult) ->
      @getCultStats(cult).ships.out -= 1
      return

    shipBuilt: (cult, portId) ->
      @getCultStats(cult).ships.out += 1
      @payShip(cult, portId)
      return

    freeShips: (cult) ->
      @getCultStats(cult).ships.no - @getCultStats(cult).ships.out

    payShip: (cult, portId) ->
      @spendGold cult, @state.ships['buildCost' + portId]
      return

    payOperationalCosts: (ship) ->
      cult = ship.cult
      cost = @getStat(cult, 'ships', 'operationCost')
      if @spendGold cult, cost
        return
      else
        app.getCollection('ships').destroyShip(ship)

    hasCultGoldToBuildShip: (cult, portId) ->
      @hasCultGold cult, @state.ships['buildCost' + portId]

    calculateBuildCost: ->
      shipState = @state.ships
      variability = shipState.buildCostVariability
      temperatureSignificance = shipState.buildCostTemperatureSignificance
      temperature = app.weather.state.temperature

      temperatureCoefficient = 1 - temperatureSignificance * (temperature - 5)
      randomness0 =  _.random(1 - variability, 1 + variability)
      randomness1 =  _.random(1 - variability, 1 + variability)
      newBuildCost0 = _.mean([shipState.buildCost0 * randomness0, temperatureCoefficient * shipState.baseBuildCost])
      newBuildCost1 = _.mean([shipState.buildCost1 * randomness1, temperatureCoefficient * shipState.baseBuildCost])
      shipState.buildCost0 = Base.round newBuildCost0
      shipState.buildCost1 = Base.round newBuildCost1
      return


    # GOLD
    earnGold: (cult, quantity) ->
      @getCultStats(cult).gold.quantity += quantity
      return

    spendGold: (cult, quantity) ->
      if @hasCultGold(cult, quantity)
        @getCultStats(cult).gold.quantity -= quantity
        true
      else
        false

    hasCultGold: (cult, quantity) ->
      @getCultStats(cult).gold.quantity > quantity

    hasPlayerGold: (quantity) ->
      @getPlayerCultStats().gold.quantity > quantity

    getCultPoliticsPoints: (cult) ->
      @getStat cult, 'politics', 'freePoints'

    getPlayerPoliticsPoints: ->
      @getPlayerStat 'politics', 'freePoints'

    getCultPoliticsMaxPoints: (cult) ->
      @getStat cult, 'politics', 'maxFreePoints'

    getPlayerPoliticsMaxPoints: ->
      @getPlayerStat 'politics', 'maxFreePoints'

    getPlayerGoldLabel: ->
      if app.game.getPlayerCultStats()
        parseInt app.game.getPlayerCultStats().gold.quantity
      else
        '0'

    getPlayerStat: (category, value) ->
      if @getPlayerCultLabel()
        @getStat @getPlayerCultLabel(), category, value
      else
        false

    getStat: (cult, category, value) ->
      @getCultStats(cult)[category][value]

    getCultStats: (cult) ->
      if @state.cults[cult]
        @state.cults[cult].stats
      else
        false

    getPlayerCultStats: ->
      if @getPlayerCultLabel()
        @getCultStats(@getPlayerCultLabel())
      else
        false

    getPlayerCult: ->
      @state.cults[@getPlayerCultLabel()]

    getPlayerColor: ->
      @getPlayerCult().color

    getPlayerCultIcon: ->
      @getPlayerCult().logo

    getPlayerCultLabel: ->
      @state.player.cult

    chooseCult: (cult) ->
      console.log 'choosing cult', cult
      @state.player.cult = cult
      return
