define 'OverviewPanel', ['Panel', 'Text', 'Button'], (Panel, Text, Button) ->
  class OverviewPanel extends Panel
    constructor: (@menu) ->
      @label = 'Overview'
      super @menu, @label

    init: ->
      super()

    draw: ->
      super()
      return
