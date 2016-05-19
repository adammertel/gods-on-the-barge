define 'ShipsPanel', ['Base', 'Panel', 'Text', 'Button', 'ButtonStyle', 'TextStyle'], (Base, Panel, Text, Button, ButtonStyle, TextStyle) ->
  class ShipsPanel extends Panel
    constructor: (@menu) ->
      @label = 'Ships'
      super @menu, @label
      return

    init: ->
      super()
      playerStats = app.game.getPlayerStat
      x = @x + 100
      dy = 12
      y = @y + 40
      l = 'shipStats'

      @dtdd {x: x, y: y, id: l + '1'}, {dt: @mst.bind(@, 'number of ships:'), dd: playerStats.bind(app.game, 'ships', 'no')}
      @dtdd {x: x, y: y + 1*dy, id: l + '2'}, {dt: @mst.bind(@, 'base speed:'), dd: playerStats.bind(app.game, 'ships', 'baseSpeed')}
      @dtdd {x: x, y: y + 2*dy, id: l + '3'}, {dt: @mst.bind(@, 'cargo:'), dd: playerStats.bind(app.game, 'ships', 'maxCargo')}
      @dtdd {x: x, y: y + 3*dy, id: l + '4'}, {dt: @mst.bind(@, 'energy:'), dd: playerStats.bind(app.game, 'ships', 'maxEnergy')}
      @dtdd {x: x, y: y + 4*dy, id: l + '5'}, {dt: @mst.bind(@, 'energy usage:'), dd: playerStats.bind(app.game, 'ships', 'energyConsumption')}
      @dtdd {x: x, y: y + 5*dy, id: l + '6'}, {dt: @mst.bind(@, 'operation cost:'), dd: playerStats.bind(app.game, 'ships', 'operationCost')}

      @dtdd {x: x, y: y + 7*dy, id: l + '7'}, {dt: @mst.bind(@, 'trading effectivity:'), dd: playerStats.bind(app.game, 'trade', 'tradeEffectivity')}

      # port
      x = @x + 200
      @registerText 'portLabel', {x: x, y: @y + 20}, @mst.bind(@, 'Port'), TextStyle.HEADER
      @registerButton 'sendShip1', {x: @x + 200, y: @y + 90, w: 180, h: 20}, @buildShipButtonText.bind(@, 0), @sendShip.bind(@, 0), @buildShipButtonStyle.bind(@, 0)
      @registerButton 'sendShip2', {x: @x + 200, y: @y + 115, w: 180, h: 20}, @buildShipButtonText.bind(@, 1), @sendShip.bind(@, 1), @buildShipButtonStyle.bind(@, 1)

      # trade
      x = @x + 350
      @registerText 'tradeLabel', {x: x, y: @y + 20}, @mst.bind(@, 'Trede'), TextStyle.HEADER


      return

    buildShipButtonStyle: (portId) ->
      playerCult = app.game.getPlayerCultLabel()
      if app.game.hasCultGoldToBuildShip playerCult, portId
        ButtonStyle.NORMALINACTIVE
      else
        ButtonStyle.NORMALDISABLED

    buildShipButtonText: (pointId)->
      if pointId == 0
        'build ship in Alexandria(' + app.game.state.ships.buildCost0 + ' gold)'
      else
        'build ship in Leuke Akte(' + app.game.state.ships.buildCost1 + ' gold)'

    drawFreeShips: ->
      playerCult = app.game.getPlayerCultLabel()
      for f in _.range(app.game.freeShips(playerCult))
        app.drawShip @ctx, {x: @x + 210 + f*30, y: @y + 40}, 2, 0, app.game.getPlayerColor()
      return

    sendShip: (startingPoint) ->
      app.game.createShip app.game.getPlayerCultLabel(), startingPoint
      return

    draw: ->
      super()
      @drawFreeShips()

      return
