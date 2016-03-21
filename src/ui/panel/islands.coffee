define 'IslandsPanel', ['Panel', 'Text', 'Button'], (Panel, Text, Button) ->
  class IslandsPanel extends Panel
    constructor: (@menu) ->
      @label = 'Islands'
      super @menu, @label

    init: () ->
      super()

    draw: ->
      super()
      return
