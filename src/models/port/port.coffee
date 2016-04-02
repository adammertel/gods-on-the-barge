define 'Port', ['Geography', 'Base'], (Geography, Base) ->
  class Port extends Geography

    constructor: (@coord, @nodeId, @island, @name)->
      return

    draw: ->
      portCoord = app.coordinateToView @coord
      radius = 5
      app.ctx.beginPath()
      app.ctx.arc portCoord.x, portCoord.y, radius*app.state.zoom, 0, 2 * Math.PI, false
      app.ctx.closePath()

      if app.state.zoom > 0.7
      if @island == 'Turkey' or @island == 'Greece' or @island == 'Egypt'
        app.ctx.fillText @name, portCoord.x, portCoord.y - 10

      app.ctx.fill()

      return
