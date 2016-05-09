define 'BackgroundIsland', ['Geography', 'Base'], (Geography, Base) ->
  class BackgroundIsland extends Geography

    constructor: (@coords, @ctx)->
      super()
      return

    calculateCoords: ->
      lastViewCoords = @viewCoords
      viewCoords = []
      @isVisible = false
      for coord, c in @coords
        viewCoord = app.coordinateToView {x: coord.x, y: coord.y}

        if !@isVisible
          if app.isPointVisible viewCoord
             @isVisible = true
        viewCoords.push viewCoord

      viewCoords

    getCoords: ->
      # coord0x = app.coordinateToView({x: @coords.x, y: 0}).x
      # if !@viewCoords or @viewCoords[0].x != coord0x
      #   @viewCoords = @calculateCoords()
      @viewCoords = @calculateCoords()
      return

    drawIsland: ->
      for viewCoord, c in @viewCoords
        if c == 0
          @ctx.moveTo viewCoord.x, viewCoord.y
        else
          @ctx.lineTo viewCoord.x, viewCoord.y
      return

    draw: ->
      @getCoords()
      if @isVisible
        @drawIsland()
      return
