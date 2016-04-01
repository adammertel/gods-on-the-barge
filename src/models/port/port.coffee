define 'Port', ['Geography', 'Base', 'FontStyle'], (Geography, Base, FontStyle) ->
  class Port extends Geography

    constructor: (@coord, @nodeId, @island, @name)->
      return

    draw: ->
      portCoord = app.coordinateToView @coord
      radius = 5
      app.ctx.beginPath()
      app.ctx.arc portCoord.x, portCoord.y, radius*app.state.zoom, 0, 2 * Math.PI, false
      app.ctx.closePath()

      app.ctx.font = FontStyle.BOLDNORMAL

      if @island == 'Turkey' or @island == 'Greece' or @island == 'Egypt'
        app.ctx.fillText @name, portCoord.x + 15, portCoord.y - 15

      app.ctx.fill()

      return
