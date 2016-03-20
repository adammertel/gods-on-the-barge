define 'Island', ['App', 'Geography', 'Base'], (app, Geography, Base) ->
  class Island extends Geography

    constructor: (@coords, data)->
      if data.population
        @data = data
      else
        @data = null
      super()
      return

    calculateCoords: ->
      viewCoords = []
      # @isVisible = false
      _.each @coords, (coord, c) =>
        viewCoord = app.coordinateToView {x: coord.x, y: coord.y}
        # if app.isPointVisible viewCoord
        #   @isVisible = true
        viewCoords.push viewCoord

      viewCoords

    getCoords: ->
      # if !@viewCoords
      #   @viewCoords = @calculateCoords()
      # else
      #   firstCoord = app.coordinateToView({x: @coords[0].x, y: @coords[0].y})
      #   if firstCoord.x != @viewCoords[0].x and firstCoord.y != @viewCoords[0].y
      #     @viewCoords = @calculateCoords()
      #
      # @viewCoords
      @viewCoords = @calculateCoords()
      return

    mouseConflict: ->
      Base.pointInsidePolygon @, app.state.controls.mousePosition

    drawInfo: ->
      index = _.indexOf app.state.geometries, @
      app.state.geometries = Base.moveAtTheEndOfArray app.state.geometries, index

      mouseX = app.state.controls.mousePosition.x
      mouseY = app.state.controls.mousePosition.y

      app.ctx.fillStyle = '#444'
      app.ctx.fillRect(mouseX + 10, mouseY + 5, 200, 100)
      app.ctx.fillStyle = 'white'
      app.ctx.fillText 'name : ' + @data.name, mouseX + 20, mouseY + 20
      app.ctx.fillText 'population : ' + @data.population, mouseX + 20, mouseY + 35

    drawIsland: ->
      app.ctx.beginPath()
      _.each @viewCoords, (viewCoord, c) =>
        if c == 0
          app.ctx.moveTo viewCoord.x, viewCoord.y
        else
          app.ctx.lineTo viewCoord.x, viewCoord.y

      app.ctx.closePath()
      app.ctx.fill()
      return

    draw: ->
      @getCoords()
      #if @isVisible
      if @data
        app.ctx.fillStyle = '#777'
        if @over
          app.ctx.fillStyle = '#555'
          @drawInfo()

        @drawIsland()

      else
        app.ctx.fillStyle = '#aaa'
        @drawIsland()

      return
