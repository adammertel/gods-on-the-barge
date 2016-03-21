define 'ShipsPanel', ['Panel', 'Text', 'Button'], (Panel, Text, Button) ->
  class ShipsPanel extends Panel
    constructor: (@menu) ->
      super @menu, 'Ships'

    draw: ->
      super()
      app.ctx.fillText @label, 200, @menu.y + @menu.h/2
      return
