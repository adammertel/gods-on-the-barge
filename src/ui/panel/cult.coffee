define 'CultPanel', ['Base', 'Panel', 'Text', 'Button', 'ButtonStyle', 'TextStyle'], (Base, Panel, Text, Button, ButtonStyle, TextStyle) ->
  class CultPanel extends Panel
    constructor: (@menu) ->
      @label = 'Cult'
      super @menu, @label
      app.registerStartGameFunction @loadCultText.bind(@)
      return

    init: ->
      x = @x + 450
      dy = 12
      y = @y + 20
      l = 'cultStats'

      @registerText 'cult stats', {x: x-20, y: y-10}, @mst.bind(@, 'Statistics'), TextStyle.CENTEREDSMALLHEADER

      @dtdd {x: x, y: y + 1*dy, id: l + '1'}, {dt: @mst.bind(@, 'total believers:'), dd: app.game.getPlayerBelievers.bind(app.game)}
      @dtdd {x: x, y: y + 2*dy, id: l + '1'}, {dt: @mst.bind(@, 'dominance on islands:'), dd: app.game.getPlayerIslands.bind(app.game)}
      @dtdd {x: x, y: y + 4*dy, id: l + '1'}, {dt: @mst.bind(@, 'mana:'), dd: @playerStat.bind(@, 'mana', 'quantity', 3)}
      @dtdd {x: x, y: y + 5*dy, id: l + '1'}, {dt: @mst.bind(@, 'mana regeneration base:'), dd: @playerStat.bind(@, 'mana', 'baseRegeneration', 3)}
      @dtdd {x: x, y: y + 7*dy, id: l + '1'}, {dt: @mst.bind(@, 'effectivity of conversion:'), dd: @playerStat.bind(@, 'religion', 'conversionEffectivity', 3)}
      @dtdd {x: x, y: y + 8*dy, id: l + '1'}, {dt: @mst.bind(@, 'resistance to conversion:'), dd: @playerStat.bind(@, 'religion', 'conversionResistance', 3)}


      super()

    playerStat: (category, attribute, prec) ->
      value = app.game.getStat app.game.getPlayerCultLabel(), category, attribute
      Base.stringToPrec(value, prec)

    loadCultText: ->
      @registerText 'cultName', {x: @x + 30, y: @y + 120}, @mst.bind(@, app.game.getPlayerCultLabel()), TextStyle.BOLD
      return

    draw: ->
      super()
      @ctx.drawImage app.game.getPlayerCultIcon(), @x + 20, @y + 40, 70, 70
      return
