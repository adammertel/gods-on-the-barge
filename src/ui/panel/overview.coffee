define 'OverviewPanel', ['Text', 'Button'], (Text, Button) ->
  class OverviewPanel
    constructor: (@menu) ->
      @label = 'Overview'

    draw: ->
      app.ctx.fillText @label, 200, @menu.y + @menu.h/2
      return
