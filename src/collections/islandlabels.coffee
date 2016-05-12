define 'IslandLabels', ['Base', 'Collection', 'Islands', 'Buildings', 'Season', 'Colors', 'FontStyle'], (Base, Collection, Islands, Buildings, Season, Colors, FontStyle) ->
  class Islands extends Collection
    constructor: (data) ->
      @name = 'islandLabels'
      super data
      @islands = app.getCollection 'islands'

      return

    registerGeometries: ->
      return

    setStyle: ->
      @ctx.font = FontStyle.BOLDNORMAL
      @ctx.globalAlpha = 0.7
      @ctx.textAlign = 'center'
      @ctx.strokeStyle = 'black'
      @ctx.lineWidth = 1

      @labelW = 80
      @labelH = 25
      return

    drawFoodIndicator: (island, centroid) ->
      fullFoodPx = @labelW - 10
      foodPx = (fullFoodPx / island.state.maxGrain) * island.state.grain
      @ctx.fillStyle = island.foodIndicatorColor()
      @ctx.strokeRect centroid.x - fullFoodPx/2, centroid.y - @labelH/2 - 8, fullFoodPx, 5
      @ctx.fillRect centroid.x - fullFoodPx/2, centroid.y - @labelH/2 - 7, foodPx, 3
      return

    draw: ->
      if app.state.zoom > 0.6

        for island in @islands.geometries
          if island.isVisible
            @ctx.fillStyle = 'white'
            centroid = app.coordinateToView island.centroid # getting centroid - here will be the label placed

            @ctx.beginPath()
            @ctx.rect centroid.x - @labelW/2, centroid.y - @labelH - 10, @labelW, @labelH
            @ctx.closePath()
            @ctx.fill()

            @ctx.fillStyle = 'black'
            @ctx.fillText island.data.name, centroid.x, centroid.y - @labelH
            @drawFoodIndicator island, centroid
        return
