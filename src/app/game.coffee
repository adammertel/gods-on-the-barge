define 'Game', ['Base', 'Colors', 'Perks', 'Events', 'Cursors', 'CultsEnum', 'Storm'], (Base, Colors, Perks, Events, Cursors, Cult, Storm) ->
  class Game
    state:
      politics:
        endingPoints: {}
      player:
        cult: ''
      islands:
        buildingAmphitheaterAttractivityBonus: 0.2
        eventFestivalAttractivityBonus: 0.3
        eventInfestationHarvestMinus: 0.3
        citizenConsumption: 0.02
        productionPerArea: 0.7
        growth: 0.01
        starvingDeathRate: 0.1
        idealRainfallMin: 500
        idealRainfallMin: 800
        criticalRainfallMin: 100
        criticalRainfallMax: 1200
      trade:
        maxBaseDistanceForTrade: 100000
        criticalCargo: 500
        baseGrainPrice: 0.03
      ships:
        buildCost0: 100
        buildCost1: 100
        baseBuildCost: 100
        buildCostVariability: 0.3
        buildCostTemperatureSignificance: 0.1
      religion:
        baseConversionMax: 120
        baseConversionMin: 50
        conversionResistancePagans: 0.2
        minDistributionToStable: 0.1
        minDistributionToGrow: 0.4
        goldForBeliever: 0.1
        flow: 0.05
      spells:
        isisTributecoefficient: 3
        anubisConversionSurplus: 20
        anubisConversionMultiplier: 30
        bastetWarMultiplier: 4
      perks:
        noNew: 2
      events:
        activeEvents: []
      gameStatistics:
        cults:
          'Serapis':
            islands: 0
            total: 0
          'Isis':
            islands: 0
            total: 0
          'Anubis':
            islands: 0
            total: 0
          'Bastet':
            islands: 0
            total: 0
          'Pagan':
            islands: 0
            total: 0

      cults:
        'Serapis':
          no: 1
          label: 'Serapis'
          iconLabel: 'serapis'
          color: Colors.CULTSERAPIS
          text: 'Has roots in the ancient royal cult of the god Osiris-Apis. Together with Isis he became the patron god of the Ptolemaic dynasty ruling during the Hellenistic period. He is an universal deity.'
          spell:
            label: 'Tribute boost'
            text: 'Get special instant tribute from local worshippers. '
            runFunctionName: 'doSpellSerapisTribute'
          stats:
            politics:
              votingEffectivity: 2
            spell:
              manaBaseCost: 5
              manaEffectivity: 1
              radius: () ->
                100
              color: Colors.CURSORSPELLSERAPISTRIBUTE
              lvl: 1

        'Isis':
          no: 2
          iconLabel: 'isis'
          label: 'Isis'
          color: Colors.CULTISIS
          text: 'She was the mother of the god Horus and her husband was Osiris. During the Hellenistic period she also became wife of the god Serapis. Isis was a universal goddess and a patron deity of sailors.'
          spell:
            label: 'Cast storm'
            text: 'Creates a storm over particular area that slows ships and brings rainfall.'
            runFunctionName: 'doSpellIsisStorm'
          stats:
            ships:
              rainPenalty: 0
            spell:
              manaBaseCost: 4
              manaEffectivity: 1
              radius: () ->
                10
              color: Colors.CURSORSPELLISISSTORM
              lvl: 1

        'Anubis':
          no: 3
          iconLabel: 'anubis'
          label: 'Anubis'
          color: Colors.CULTANUBIS
          text: 'He is known as the god with a jackall head. He weighed the hearts of dead people in the final judgement. He was a patron deity of funeral rites and protected people in their afterlife.'
          spell:
            label: 'Sailors conversion'
            text: 'Captures all ships within selected radius for a single trip.'
            runFunctionName: 'doSpellAnubisConversion'
          stats:
            ships:
              operationCost: 0
            spell:
              manaBaseCost: 8
              manaEffectivity: 1
              radius: () ->
                lvl = app.game.state.cults['Anubis'].stats.spell.lvl
                app.game.state.spells.anubisConversionMultiplier * lvl + app.game.state.spells.anubisConversionSurplus
              color: Colors.CURSORSPELLANUBISCONVERSION
              lvl: 1

        'Bastet':
          no: 4
          iconLabel: 'bastet'
          label: 'Bastet'
          color: Colors.CULTBASTET
          text: 'She was the famous lion goddess of Egypt. She is known for her temper and protective behaviour. She was also the patron deity of hunters and mothers.'
          spell:
            label: 'Political crisis'
            text: 'Sends war to selected island'
            runFunctionName: 'doSpellBastetCrisis'
          stats:
            spell:
              manaBaseCost: 4
              manaEffectivity: 1
              radius: () ->
                100
              color: Colors.CURSORSPELLBASTETCRISIS
              lvl: 1

    defaultCultStats:
      religion:
        conversionEffectivity: 1
        conversionResistance: 0.3
      gold:
        quantity: 1000
      mana:
        quantity: 5
        baseRegeneration: 1
        maxQuantity: 10
      politics:
        pointRegeneration: 1
        freePoints: 2
        maxFreePoints: 3
        votingEffectivity: 1
      ships:
        no: 3
        out: 0
        baseSpeed: 0.5
        maxCargo: 100000
        maxEnergy: 1000
        energyConsumption: 40
        restingSpeed: 120
        operationCost: 0.5
        rainPenalty: 0.5
      trade:
        tradingDistanceCoefficient: 1
        tradeEffectivity: 1

    constructor: ->
      @loadIcons()
      @loadStats()
      @loadPolitics()

      app.registerNewDayAction @calculateBuildCost.bind @
      app.registerNewDayAction @recalculateTotalBelievers.bind @
      app.registerNewWeekAction @randomPolitics.bind @
      app.registerNewWeekAction @eventsEmitter.bind @

      app.registerNewWeekAction @addNewPoliticsPoints.bind @
      app.registerNewSeasonAction @chooseNewPerks.bind @
      app.registerNewSeasonAction @getMoneyForBelievers.bind @

      app.registerNewWeekAction @regenerateMana.bind @

      app.registerNewWeekAction @incrementBaseShipCost.bind @


    incrementBaseShipCost: ->
      @state.ships.baseBuildCost *= Math.random()/10 + 1
      return

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

    getMoneyForBelievers: ->
      for cultName, cult of @state.cults
        goldFromBelievers = @state.gameStatistics.cults[cultName].total * @state.religion.goldForBeliever
        console.log 'cult', cultName, 'gains ', goldFromBelievers
        @earnGold cultName, goldFromBelievers
      return


    # MANA
    regenerateMana: ->
      for cultName, cult of @state.cults
        newMana = @manaRegenerationQuantity @getCultStats(cultName).mana.baseRegeneration
        @addMana cultName, newMana
      return

    manaRegenerationQuantity: (base) ->
      0.5 * Math.random() * base + 0.3

    addMana: (cult, quantity) ->
      maxPossibleMana = @getCultStats(cult).mana.maxQuantity
      @getCultStats(cult).mana.quantity = _.clamp(@getCultStats(cult).mana.quantity + quantity, 0, maxPossibleMana)
      return

    # returns boolean - was the mana was really spent?
    spendMana: (cult, quantity) ->
      if @hasEnoughtMana cult, quantity
        @getCultStats(cult).mana.quantity -= quantity
        true
      else
        false

    hasEnoughtMana: (cult, quantity) ->
      !(@getCultStats(cult).mana.quantity < quantity)


    # EVENTS
    eventsEmitter: ->
      for island in app.getCollection('islands').geometries
        if island.state.event
          island.state.event.time -= 1
          if island.state.event.time < 0
            island.state.event = null

        else
          for evName of Events
            event = Events[evName]
            if Math.random() < 1/event['frequency']
              if event['condition'](island)
                evLen = _.random(event['length'][0], event['length'][1])
                newEv = _.clone(event)
                newEv.time = evLen
                island.eventHappens(newEv)
      return

    # RELIGION
    recalculateTotalBelievers: ->

      totals =
        Serapis: 0
        Isis: 0
        Anubis: 0
        Bastet: 0
        Pagan: 0
      islands =
        Serapis: 0
        Isis: 0
        Anubis: 0
        Bastet: 0
        Pagan: 0

      for island in app.getCollection('islands').geometries
        islands[island.getDominantCult()] += 1

        for cultName, cult of island.state.religion
          onePerson = 1 / island.state.population
          totals[cultName] += Base.round(cult.distribution / onePerson)

      for cultName, total of totals
        @state.gameStatistics.cults[cultName].total = total

      for cultName, noIslands of islands
        if @state.gameStatistics.cults[cultName]
          @state.gameStatistics.cults[cultName].islands = noIslands
        else
          console.log '****************************'
          console.log islands
          console.log totals
          console.log '****************************'

      return


    # SPELLS
    preparePlayerSpell: ->
      playerCult = app.game.getPlayerCultLabel()
      playerCultStats = app.game.getPlayerCultStats()

      if app.game.hasEnoughtMana(playerCult, app.game.manaSpellCost playerCultStats)
        app.changeCursor Cursors.SPELL
        app.state.spellReady = true
        app.time.pause()
      return

    cancelPlayerSpell: ->
      console.log 'cancel'
      app.changeCursor Cursors.DEFAULT
      app.state.spellReady = false
      app.time.resume()
      return

    playerSpellCheck: ->
      if app.mouseOverMap()
        console.log 'over map spell run'
        cult = @getPlayerCultLabel()
        spellFnName = app.game.state.cults[cult].spell.runFunctionName
        app.game[spellFnName] app.mouseCoordinate()
        app.state.spellReady = false

        app.changeCursor Cursors.DEFAULT
        app.time.resume()


    manaSpellCost: (cultStats) ->
      cultStats.spell.manaBaseCost * cultStats.spell.manaEffectivity


    doSpellSerapisTribute: (centroid) ->
      cult = Cult['SERAPIS']
      cultStats = @getCultStats(cult)

      islands = @itemsInRadius app.getCollection('islands'), centroid, cultStats.spell.radius()
      for island in islands
        believersNo = island.state.religion[cult].distribution * island.state.population
        goldFromBelievers = believersNo * _.random(0.5, cultStats.spell.lvl) * app.game.state.spells.isisTributecoefficient
        @earnGold cult, goldFromBelievers

      mana = @manaSpellCost cultStats
      @spendMana cult, mana
      return


    doSpellIsisStorm: (centroid) ->
      cult = Cult['ISIS']
      cultStats = @getCultStats(cult)
      mana = @manaSpellCost cultStats

      stormsColection = app.getCollection 'storms'
      stormsColection.addGeometry new Storm(app.weather.state.lastStormId, centroid, _.random(2, cultStats.spell.lvl * 2))
      app.weather.state.lastStormId += 1

      @spendMana cult, mana


    doSpellAnubisConversion: (centroid) ->
      cult = Cult['ANUBIS']
      cultStats = @getCultStats(cult)
      mana = @manaSpellCost cultStats

      spellsConfig = app.game.state.spells
      radius = cultStats.spell.radius()

      ships = @itemsInRadius app.getCollection('ships'), centroid, radius
      for ship in ships
        ship.cult = cult

      @spendMana cult, mana


    doSpellBastetCrisis: (centroid) ->
      cult = Cult['BASTET']
      cultStats = @getCultStats(cult)
      mana = @manaSpellCost cultStats

      islands = @itemsInRadius app.getCollection('islands'), centroid, cultStats.spell.radius()
      for island in islands
        warEvent = _.clone(Events.WAR)
        warEvent.time = parseInt(_.random(1, cultStats.spell.lvl * app.game.state.spells.bastetWarMultiplier))
        island.eventHappens warEvent

      @spendMana cult, mana


    itemsInRadius: (collection, centroid, radius) ->
      collection.geomsInRadius(centroid, radius)


    # CONVERSIONS
    numberOfConverting: (cult) ->
      baseMax = @state.religion.baseConversionMax
      baseMin = @state.religion.baseConversionMin
      baseConverted = _.random(baseMin, baseMax)
      conversionEffectivity = @getStat(cult, 'religion', 'conversionEffectivity')
      Base.round baseConverted * conversionEffectivity


    makeConversion: (cult, island, numberOfConverting) ->
      #console.log 'making religious conversion driven by ship. Island name: ', island.state.name
      #console.log 'numberOfConverting ', numberOfConverting
      onePersonDistribution = 1 / island.state.population
      conversionEffectivity = @getStat(cult, 'religion', 'conversionEffectivity')

      for n in _.range numberOfConverting
        randomPersonReligion = @getRandomPersonReligionFromIsland(island)

        if randomPersonReligion != cult
          resistance = @getResistanceOfCult randomPersonReligion
          conversionChance = conversionEffectivity - resistance
          if Math.random() < conversionChance
            @convertPerson island, randomPersonReligion, cult, onePersonDistribution

      return

    convertPerson: (island, cultFrom, cultTo, onePersonDistribution) ->
      if island.state.religion[cultFrom].distribution >= onePersonDistribution
        island.state.religion[cultFrom].distribution -= onePersonDistribution
        island.state.religion[cultTo].distribution += onePersonDistribution
      return


    getResistanceOfCult: (cult) ->
      if cult == 'Pagan'
        @state.religion.conversionResistancePagans
      else
         @getStat(cult, 'religion', 'conversionResistance')


    getRandomPersonReligionFromIsland: (island) ->
      SerapisCumulation = island.state.religion.Serapis.distribution
      IsisCumulation = SerapisCumulation + island.state.religion.Isis.distribution
      BastetCumulation = IsisCumulation + island.state.religion.Bastet.distribution
      AnubisCumulation = BastetCumulation + island.state.religion.Anubis.distribution

      randomNumber = Math.random()

      if (randomNumber < SerapisCumulation)
        'Serapis'
      else if (randomNumber < IsisCumulation)
        'Isis'
      else if (randomNumber < BastetCumulation)
        'Bastet'
      else if (randomNumber < AnubisCumulation)
        'Anubis'
      else
        'Pagan'


    # TRADING
    maxTradingDistanceForCult: (cult) ->
      @getStat(cult, 'trade', 'tradingDistanceCoefficient') * @state.trade.maxBaseDistanceForTrade

    makeTrade: (ship, island) ->
      if island.inWar()
        return
      else
        cult = ship.cult
        grain = ship.cargo

        islandsCollection = app.getCollection('islands')

        quantityCoefficient = islandsCollection.hungryCoefficient(island) * Math.random()
        quantity = ship.validateCargoQuantity(quantityCoefficient * islandsCollection.missingGrain(island))

        #console.log 'will trade, ' , quantity
        islandsCollection.addGrainToIsland island, quantity
        ship.unshipCargo quantity

        totalPrice = quantity * @getStat(cult, 'trade', 'tradeEffectivity') * @getGrainPrice()
        @earnGold cult, totalPrice
        return

    getGrainPrice: ->
      @state.trade.baseGrainPrice


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
        game.raiseEndingPoint randomEndingPointToRaise, 1

      lowerRandomPoint()
      lowerRandomPoint()
      lowerRandomPoint()
      raiseRandomPoint()

      return

    raiseEndingPoint: (endingPointId, points) ->
      if @state.politics.endingPoints[endingPointId] < 10
        @state.politics.endingPoints[endingPointId] += points
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
        if @raiseEndingPoint(endingPointId, @getStat cult, 'politics', 'votingEffectivity')
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

    getCultPoliticsPoints: (cult) ->
      @getStat cult, 'politics', 'freePoints'

    getPlayerPoliticsPoints: ->
      @getPlayerStat 'politics', 'freePoints'

    getCultPoliticsMaxPoints: (cult) ->
      @getStat cult, 'politics', 'maxFreePoints'

    getPlayerPoliticsMaxPoints: ->
      @getPlayerStat 'politics', 'maxFreePoints'

    getPlayerBelievers: ->
      @getCultBelievers app.game.getPlayerCultLabel()

    getCultBelievers: (cult) ->
      app.game.state.gameStatistics.cults[cult].total

    getPlayerIslands: ->
      @state.gameStatistics.cults[app.game.getPlayerCultLabel()].islands


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
      @getCultStats(cult).ships.no - app.getCollection('ships').getShipsOfCult(cult).length

    payShip: (cult, portId) ->
      @spendGold cult, @state.ships['buildCost' + portId]
      return

    payOperationalCosts: (ship) ->
      if ship
        cult = ship.cult
        cost = @getStat(cult, 'ships', 'operationCost')
        if @spendGold cult, cost
          return
        else
          app.getCollection('ships').destroyShip(ship)
      return

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

    getPlayerGoldLabel: ->
      if app.game.getPlayerCultStats()
        parseInt app.game.getPlayerCultStats().gold.quantity
      else
        '0'


    # GENERAL METHODS
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


    # PERKS
    chooseNewPerks: ->
      for c, cult of @state.cults
        if c == @getPlayerCultLabel()
          chosenPerks = _.sampleSize Perks, @state.perks.noNew
          app.openPerkWindow(chosenPerks)
        else
          chosenPerk = _.sample(Perks)
          chosenPerk.effect(c)
      return

    applyPerkToPlayer: (perk) ->
      perk.effect(@getPlayerCultLabel())
      return
