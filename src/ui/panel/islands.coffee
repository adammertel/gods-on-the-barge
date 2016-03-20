define 'IslandsPanel', ['Text', 'Button'], (Text, Button) ->
  class IslandsPanel
    constructor: (@menu) ->
      @label = 'Islands'

    draw: ->
      app.ctx.fillStyle = 'black'
      app.ctx.fillText @label, 200, @menu.y + @menu.h/2
      return
