define 'Island', ['App', 'Geography', 'Base', 'Colors'], (app, Geography, Base, Colors) ->
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
        rainfall: 0
        starving: 0
        active: false
      }
      @collection = app.getCollection 'islands'

      if data.population
        @data = data
      else
        @data = null

      @calculateCentroid()
      if @state.name == 'Delos'
        @centroid.y += 30
      super()
      return

    calculateCentroid: ->
      xs = []
      ys = []
      for c in @coords
        xs.push c.x
        ys.push c.y
      @centroid = {x: _.mean(xs), y: _.mean(ys)}
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
      @pointConflict app.state.controls.mousePosition

    pointConflict: (point)->
      Base.pointInsidePolygon @, point

    # should be simplified to some representative coordinates
    distanceFromIsland: (point) ->
      Base.distanceFromPolygon @coords, point

    drawLabelBackground: (w, h)->
      @centroidCoord = app.coordinateToView @centroid
      app.ctx.rect @centroidCoord.x - w/2, @centroidCoord.y - h - 10, w, h

    drawLabel: (w, h) ->
      app.ctx.fillText @data.name, @centroidCoord.x, @centroidCoord.y - h

    drawFoodIndicator: (w, h) ->
      fullFoodPx = w - 10
      foodPx = (fullFoodPx / @state.maxGrain) * @state.grain
      app.ctx.fillStyle = @foodIndicatorColor()
      app.ctx.strokeRect @centroidCoord.x - fullFoodPx/2, @centroidCoord.y - h/2 - 8, fullFoodPx, 5
      app.ctx.fillRect @centroidCoord.x - fullFoodPx/2, @centroidCoord.y - h/2 - 7, foodPx, 3
      return

    foodIndicatorColor: ->
      foodRelative = @state.grain/@state.maxGrain
      if foodRelative > 0.8
        Colors.FOODINDICATORSUPER
      else if foodRelative > 0.5
        Colors.FOODINDICATORGOOD
      else if foodRelative > 0.25
        Colors.FOODINDICATORBAD
      else
        Colors.FOODINDICATORCRITICAL

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
