define 'Island', ['App', 'Geography', 'Base'], (app, Geography, Base) ->
  class Island extends Geography

    constructor: (@coords, data)->
      @state = {
        buildings:
          hospital: false
          granary: false
          amphiteater: false
          dock: false
        name: data.name
        population: data.population
        area: data.area
        grain: Base.round data.population * _.random 0.7, 2
        harvestHistory: []
        maxGrain: data.population * 2
        starving: 0
        active: false
      }
      @collection = app.getCollection 'islands'

      if data.population
        @data = data
      else
        @data = null

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
      # coord0x = app.coordinateToView({x: @coords.x, y: 0}).x
      # if !@viewCoords or @viewCoords[0].x != coord0x
      #   @viewCoords = @calculateCoords()
      @viewCoords = @calculateCoords()
      return

    mouseConflict: ->
      Base.pointInsidePolygon @, app.state.controls.mousePosition

    drawLabelBackground: ->
      app.ctx.rect @viewCoords[0].x - 5, @viewCoords[0].y - 10, app.ctx.measureText(@data.name).width + 10, 15

    drawLabel: ->
      app.ctx.fillText @data.name, @viewCoords[0].x, @viewCoords[0].y

    drawIsland: ->
      for viewCoord, c in @viewCoords
        if c == 0
          app.ctx.moveTo viewCoord.x, viewCoord.y
        else
          app.ctx.lineTo viewCoord.x, viewCoord.y

      return

    highlight: ->
      app.ctx.beginPath()
      @drawIsland()
      app.ctx.closePath()
      app.ctx.stroke()

    draw: ->
      @getCoords()
      if @isVisible
        @drawIsland()
      return
