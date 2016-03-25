define 'Game', ['Base'], (Base) ->
  class Game
    state:
      player:
        cult: ''
      cults:
        'Serapis':
          no: 1
          label: 'Serapis'
          iconLabel: 'serapis'
          color: '#377eb8'
          text: 'Serapis was a god of blablabla'
          stats:
            ships:
              maxEnergy: 500
        'Isis':
          no: 2
          iconLabel: 'isis'
          label: 'Isis'
          color: '#4daf4a'
          text: 'Isis was a goddess of something else and blablabla...'
          stats:
            ships:
              maxCargo: 1500
        'Anubis':
          no: 3
          iconLabel: 'anubis'
          label: 'Anubis'
          color: '#a65628'
          text: 'And also Anubis was here. He was a blablabla...'
          stats:
            ships:
              operationCost: 0.15
        'Bastet':
          no: 4
          iconLabel: 'bastet'
          label: 'Bastet'
          color: '#e41a1c'
          text: 'Bastet is the last one here but not blablabla...'
          stats: {}

    defaultCultStats:
      gold:
        quantity: 1000
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

    loadStats: ->
      _.each @state.cults, (cult, cultLabel) =>
        defaultCultStats = _.clone(@defaultCultStats)
        cultStats = _.clone(cult.stats)
        @state.cults[cultLabel].stats = _.merge({}, defaultCultStats, cultStats)
        return

      return



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

    getPlayerCult: () ->
      @state.cults[@getPlayerCultLabel()]

    getPlayerColor: () ->
      @getPlayerCult().color

    getPlayerCultIcon: ->
      @getPlayerCult().logo

    getPlayerCultLabel: ->
      @state.player.cult

    chooseCult: (cult) ->
      console.log 'choosing cult', cult
      @state.player.cult = cult
      return

    shipRemoved: (cult) ->
      @getCultStats(cult).ships.out -= 1
      return

    shipBuilt: (cult) ->
      @getCultStats(cult).ships.out += 1
      return

    freeShips: (cult) ->
      @getCultStats(cult).ships.no - @getCultStats(cult).ships.out

    loadIcons: ->
      _.each @state.cults, (cult, cultLabel) =>
        cult.logo = Base.loadIcon cult.iconLabel, cult.color
        return
      return

    getPlayerMoney: ->
      app.game.getPlayerCultStats().gold.quantity
