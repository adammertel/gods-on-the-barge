define 'CultPanel', ['Panel', 'Text', 'Button'], (Panel, Text, Button) ->
  class CultPanel extends Panel
    constructor: (@menu) ->
      super @menu, 'Cult'

    draw: () ->
      super()
      app.ctx.fillText @label, 200, @menu.y + @menu.h/2
      return
