define 'ShipsPanel', ['Base', 'Panel', 'Text', 'Button', 'ButtonStyle', 'TextStyle'], (Base, Panel, Text, Button, ButtonStyle, TextStyle) ->
  class ShipsPanel extends Panel
    constructor: (@menu) ->
      @label = 'Ships'
      super @menu, @label
      return

    init: ->
      super()
      shipStats = app.game.getPlayerStat
      x = @x + 100
      ss = 'shipStats'

      @dtdd {x: x, y: @y + 50, id: ss + '1'}, {dt: @mst.bind(@, 'number:'), dd: shipStats.bind(app.game, 'ships', 'no')}
      @dtdd {x: x, y: @y + 60, id: ss + '2'}, {dt: @mst.bind(@, 'base speed:'), dd: shipStats.bind(app.game, 'ships', 'baseSpeed')}
      @dtdd {x: x, y: @y + 70, id: ss + '3'}, {dt: @mst.bind(@, 'cargo:'), dd: shipStats.bind(app.game, 'ships', 'maxCargo')}
      @dtdd {x: x, y: @y + 80, id: ss + '4'}, {dt: @mst.bind(@, 'energy:'), dd: shipStats.bind(app.game, 'ships', 'maxEnergy')}
      @dtdd {x: x, y: @y + 90, id: ss + '5'}, {dt: @mst.bind(@, 'energy usage:'), dd: shipStats.bind(app.game, 'ships', 'energyConsumption')}
      @dtdd {x: x, y: @y + 100, id: ss + '6'}, {dt: @mst.bind(@, 'operation cost:'), dd: shipStats.bind(app.game, 'ships', 'operationCost')}

      # port
      x = @x + 200
      @registerText 'portLabel', {x: x, y: @y + 20}, @mst.bind(@, 'Port'), TextStyle.HEADER
      @registerButton 'sendShip1', {x: @x + 200, y: @y + 90, w: 180, h: 20}, @buildShipButtonText.bind(@, 0), @sendShip.bind(@, 0), @buildShipButtonStyle.bind(@, 0)
      @registerButton 'sendShip2', {x: @x + 200, y: @y + 115, w: 180, h: 20}, @buildShipButtonText.bind(@, 1), @sendShip.bind(@, 1), @buildShipButtonStyle.bind(@, 1)
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
      for f in _.range(app.game.freeShips playerCult)
        app.drawShip {x: @x + 210 + f*30, y: @y + 40}, 2, 0, app.game.getPlayerColor()
      return

    sendShip: (startingPoint) ->
      console.log startingPoint
      app.game.createShip app.game.getPlayerCultLabel(), startingPoint
      return

    draw: ->
      super()
      @drawFreeShips()

      return
