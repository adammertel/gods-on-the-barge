define 'ShipsPanel', ['Base', 'Panel', 'Text', 'Button'], (Base, Panel, Text, Button) ->
  class ShipsPanel extends Panel
    constructor: (@menu) ->
      @label = 'Ships'
      super @menu, @label
      return

    init: ->
      super()
      bs = _.clone @buttonStyle
      bs.inactive.font = 'bold 12pt Calibri'
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
      @registerText 'portLabel', {x: x, y: @y + 20}, @mst.bind(@, 'Port'), @headerStyle
      @registerButton 'sendShip', {x: @x + 200, y: @y + 100, w: 120, h: 40}, @makeStaticText.bind(@, 'send ship'), @sendShip.bind(@), bs, false
      return

    drawFreeShips: ->
      playerCult = app.game.getPlayerCultLabel()
      for f in _.range(app.game.freeShips playerCult)
        app.drawShip {x: @x + 210 + f*30, y: @y + 40}, 2, 0, app.game.getPlayerColor()
      return

    sendShip: ->
      app.getCollection('ships').createShip(app.game.getPlayerCultLabel())
      return

    draw: ->
      super()
      @drawFreeShips()

      return
