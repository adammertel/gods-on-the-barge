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
      ships:
        buildCost: 100
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
              maxCargo: 1500
        'Anubis':
          no: 3
          iconLabel: 'anubis'
          label: 'Anubis'
          color: Colors.CULTANUBIS
          text: 'And also Anubis was here. He was a blablabla...'
          stats:
            ships:
              operationCost: 0.15
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
        maxCargo: 1000
        maxEnergy: 400
        energyConsumption: 40
        restingSpeed: 120
        operationCost: 0.1
        rainPenalty: 0.3

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
    createShip: (cult, startingPoint) ->
      if @freeShips(cult) > 0 and @hasCultGoldToBuildShip(cult)
        @shipBuilt(cult)
        app.getCollection('ships').createShip cult, startingPoint

    shipRemoved: (cult) ->
      @getCultStats(cult).ships.out -= 1
      return

    shipBuilt: (cult) ->
      @getCultStats(cult).ships.out += 1
      @payShip(cult)
      return

    freeShips: (cult) ->
      @getCultStats(cult).ships.no - @getCultStats(cult).ships.out

    payShip: (cult) ->
      @spendGold cult, @state.ships.buildCost
      return

    hasCultGoldToBuildShip: (cult) ->
      @hasCultGold cult, @state.ships.buildCost

    calculateBuildCost: ->
      gameState = @state.ships
      variability = gameState.buildCostVariability
      temperatureSignificance = gameState.buildCostTemperatureSignificance
      temperature = app.weather.state.temperature

      temperatureCoefficient = 1 - temperatureSignificance * (temperature - 5)
      randomness =  _.random(1 - variability, 1 + variability)
      newBuildCost = _.mean([gameState.buildCost * randomness, temperatureCoefficient * gameState.baseBuildCost])
      gameState.buildCost = Base.round newBuildCost
      return


    # GOLD
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

    getPlayerMoney: ->
      app.game.getPlayerCultStats().gold.quantity

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
