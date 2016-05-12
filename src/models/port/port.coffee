define 'Port', ['Geography', 'Base'], (Geography, Base) ->
  class Port extends Geography

    constructor: (@coord, @ctx, @nodeId, @island, @name)->
      return

    draw: ->
      portCoord = app.coordinateToView @coord
      radius = 3
      @ctx.beginPath()
      @ctx.arc portCoord.x, portCoord.y, radius*app.state.zoom, 0, 2 * Math.PI, false
      @ctx.closePath()

      if app.state.zoom > 0.6
        if @island == 'Turkey' or @island == 'Greece' or @island == 'Egypt'
          @ctx.fillText @name, portCoord.x, portCoord.y - 10

      @ctx.fill()

      return
