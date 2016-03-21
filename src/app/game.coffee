define 'Game', ['Base'], (Base) ->
  class Game
    state:
      playerCult: ''
      cults:
        'Serapis':
          no: 1
          label: 'Serapis'
          iconLabel: 'serapis'
          color: '#377eb8'
          text: 'Serapis was a god of blablabla'
          stats: {}
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
      ships:
        no: 3
        baseSpeed: 1
        maxCargo: 1000
        maxEnergy: 400
        energyConsumption: 0.5
        restingSpeed: 20
        operationCost: 0.1

    constructor: ->
      @loadIcons()
      @loadStats()

    loadStats: ->
      _.each @state.cults, (cult, cultLabel) =>
        cult.stats = _.merge(@defaultCultStats, cult.stats)
      return

    getCultStats: (cult) ->
      @state.cults[cult].stats

    getChosenCultIcon: ->
      @state.cults[@getChosenCultLabel()].logo

    getChosenCultLabel: ->
      app.state.player.cult

    loadIcons: () ->
      _.each @state.cults, (cult, cultLabel) =>
        xhr = Base.doXhr './sprites/' + cult.iconLabel + '.svg'
        img = new Image()
        svg = new XMLSerializer().serializeToString xhr.responseXML.documentElement
        svg = svg.replace(new RegExp('#666666', 'g'), cult.color) # change color
        img.src = 'data:image/svg+xml;base64,' + btoa unescape encodeURIComponent svg
        cult.logo = img
        return
      return
