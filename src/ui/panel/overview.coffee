define 'OverviewPanel', ['Panel', 'Text', 'Button'], (Panel, Text, Button) ->
  class OverviewPanel extends Panel
    constructor: (@menu) ->
      super @menu, 'Overview'

    draw: ->
      super()
      app.ctx.fillText @label, 200, @menu.y + @menu.h/2
      return
