define 'CultPanel', ['Text', 'Button'], (Text, Button) ->
  class CultPanel
    constructor: (@menu) ->
      @label = 'Cult'

    draw: ->
      app.ctx.fillStyle = 'black'
      app.ctx.fillText @label, 200, @menu.y + @menu.h/2
      return
