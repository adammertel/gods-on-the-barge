define 'ShipsPanel', ['Panel', 'Text', 'Button'], (Panel, Text, Button) ->
  class ShipsPanel extends Panel
    constructor: (@menu) ->
      @label = 'Ships'
      super @menu, @label

    init: () ->
      super()

    draw: ->
      super()
      return
