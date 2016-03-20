define 'ShipsPanel', ['Text', 'Button'], (Text, Button) ->
  class ShipsPanel
    constructor: (@menu) ->
      @label = 'Ships'

    draw: ->
      app.ctx.fillText @label, 200, @menu.y + @menu.h/2
      return
