define 'WeatherPanel', ['Panel', 'Text', 'Button'], (Panel, Text, Button) ->
  class WeatherPanel extends Panel
    constructor: (@menu) ->
      @label = 'Weather'
      super @menu, @label
      return

    init: () ->
      super()



    draw: () ->
      super()
      return
