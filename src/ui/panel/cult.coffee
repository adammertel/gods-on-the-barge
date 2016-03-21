define 'CultPanel', ['Panel', 'Text', 'Button'], (Panel, Text, Button) ->
  class CultPanel extends Panel
    constructor: (@menu) ->
      @label = 'Cult'
      super @menu, @label
      return

    init: () ->
      @registerText 'cultName', {x: @x + 20, y: @y + 40}, app.game.getChosenCultLabel.bind(@), @textStyle
      super()



    draw: () ->
      super()
      app.ctx.drawImage app.game.getChosenCultIcon(), @x + 20, @y + 60, 70, 70
      return
