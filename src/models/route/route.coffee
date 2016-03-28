define 'Route', ['App', 'Geography', 'Base'], (app, Geography, Base) ->
  class Route extends Geography

    constructor: (@from, @to)->
      @speed = 5
      super()
      return
