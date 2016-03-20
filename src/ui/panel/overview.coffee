define 'OverviewPanel', ['Text', 'Button'], (Text, Button) ->
  class OverviewPanel
    constructor: (@menu) ->
      @label = 'Overview'

    draw: ->
      app.ctx.fillStyle = 'black'
      app.ctx.fillText @label, 200, @menu.y + @menu.h/2
      return
