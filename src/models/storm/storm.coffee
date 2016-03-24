define 'Storm', ['Geography', 'Base'], (Geography, Base) ->
  class Storm extends Geography

    constructor: (@id)->
      @power = _.random(4, 8, false)
      super()
      return

    reducePower: () ->
      @power -= 1
      if @power < 1
        app.weather.disbandStorm @id
      return

    draw: ->
      return
