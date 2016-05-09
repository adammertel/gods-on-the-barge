define 'CultPanel', ['Panel', 'Text', 'Button', 'ButtonStyle', 'TextStyle'], (Panel, Text, Button, ButtonStyle, TextStyle) ->
  class CultPanel extends Panel
    constructor: (@menu) ->
      @label = 'Cult'
      super @menu, @label
      app.registerStartGameFunction @loadCultText.bind(@)
      return

    init: ->
      super()

    loadCultText: ->
      @registerText 'cultName', {x: @x + 20, y: @y + 40}, @mst.bind(@, app.game.getPlayerCultLabel()), TextStyle.BOLD
      return

    draw: ->
      super()
      @ctx.drawImage app.game.getPlayerCultIcon(), @x + 20, @y + 60, 70, 70
      return
