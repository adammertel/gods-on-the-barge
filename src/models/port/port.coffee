define 'Port', ['Geography', 'Base'], (Geography, Base) ->
  class Port extends Geography

    constructor: (@coord, @nodeId, @name)->
      super()
      return

    draw: ->
      portCoord = app.coordinateToView @coord
      if @name
        app.ctx.fillStyle = 'red'
        radius = 5
      else
        app.ctx.fillStyle = 'black'
        radius = 3

      #console.log portCoord
      app.ctx.beginPath()
      app.ctx.arc(portCoord.x, portCoord.y, radius*app.state.zoom, 0, 2 * Math.PI, false)
      app.ctx.fill()
      app.ctx.fillText @nodeId, portCoord.x + 10, portCoord.y + 10
      return
