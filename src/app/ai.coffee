define 'Ai', ['Base'], (Base) ->
  class Ai
    state:
      shipBuildChange: 0.1 + Math.random()/20
      voteforContinent: 0.1 + Math.random()/10

    constructor: (@cult) ->
      @state.strategyContinent = if Math.random() > 0.5 then 'Turkey' else 'Greece'
      @state.strategyPorts = app.getCollection('nodes').getNodesOnIsland(@state.strategyContinent)

      @state.anotherContinent = if @state.strategyContinent == 'Turkey' then 'Greece' else 'Greece'
      @state.otherPorts = app.getCollection('nodes').getNodesOnIsland(@state.anotherContinent)

      app.registerNewDayAction @sendShip.bind @
      app.registerNewWeekAction @vote.bind @


    sendShip: ->
      if Math.random() < @state.shipBuildChange
        portId = if app.game.state.ships.buildCost0 < app.game.state.ships.buildCost1 then 0 else 1
        app.game.createShip @cult, portId
      return

    vote: ->
      if Math.random() < @state.voteforContinent
        nodeId = app.getCollection('nodes').getIdOfNode _.sample(@state.strategyPorts)
      else
        nodeId = app.getCollection('nodes').getIdOfNode _.sample(@state.otherPorts)

      app.game.voteForEndingPoint @cult, nodeId
      return
