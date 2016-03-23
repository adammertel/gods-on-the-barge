define 'BackgroundIsland', ['App', 'Geography', 'Base'], (app, Geography, Base) ->
  class BackgroundIsland extends Geography

    constructor: (@coords)->
      super()
      return

    calculateCoords: ->
      viewCoords = []
      @isVisible = false
      for coord in @coords
        viewCoord = app.coordinateToView {x: coord.x, y: coord.y}
        if !@isVisible
          if app.isPointVisible viewCoord
             @isVisible = true
        viewCoords.push viewCoord

      viewCoords

    getCoords: ->
      @viewCoords = @calculateCoords()
      return

    drawIsland: ->
      app.ctx.beginPath()
      for viewCoord, c in @viewCoords
        if c == 0
          app.ctx.moveTo viewCoord.x, viewCoord.y
        else
          app.ctx.lineTo viewCoord.x, viewCoord.y

      app.ctx.closePath()
      app.ctx.fillStyle = '#ccc'
      app.ctx.fill()
      return

    draw: ->
      @getCoords()
      if @isVisible
        @drawIsland()
      return
