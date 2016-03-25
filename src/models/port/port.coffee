define 'Port', ['Geography', 'Base'], (Geography, Base) ->
  class Port extends Geography

    constructor: (@coord, @nodeId, @name)->
      super()
      return

    draw: ->
      portCoord = app.coordinateToView @coord
      radius = 5
      app.ctx.beginPath()
      app.ctx.arc(portCoord.x, portCoord.y, radius*app.state.zoom, 0, 2 * Math.PI, false)
      app.ctx.fill()
      app.ctx.closePath()
      return
