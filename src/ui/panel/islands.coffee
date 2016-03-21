define 'IslandsPanel', ['Panel', 'Text', 'Button'], (Panel, Text, Button) ->
  class IslandsPanel extends Panel
    constructor: (@menu) ->
      super @menu, 'Islands'

    draw: ->
      super()
      app.ctx.fillText @label, 200, @menu.y + @menu.h/2
      return
