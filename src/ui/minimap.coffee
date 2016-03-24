define 'MiniMap', ['Base'], (Base) ->
  class MiniMap
    constructor: () ->
      @h = 150
      @w = app.state.map.w / app.state.map.h * @h
      @x = app.state.view.w - @w - 1
      @y = app.state.view.h - @h - 1
      @lw = 2
      @dx = @w / app.state.map.w
      @dy = @h / app.state.map.h

      pathCoords = [[@x, @y], [@x, @y + @h], [@x + @w, @y + @h], [@x + @w, @y]]
      @path = new Path2D Base.buildPathString(pathCoords, true)

      @islandPaths = []
      @getIslandPaths()
      return

    coordinateToMiniMap: (c) ->
      x: Base.round(@x + @dx * c.x)
      y: Base.round(@y + @dy * c.y)

    getIslandPaths:() ->
      @islandPaths = []
      islands = app.getCollection 'islands'
      bckIslands = app.getCollection 'backgroundIslands'

      for islandGeometry in islands.geometries
        islandCoords = []
        if islandGeometry.coords.length > 80
          for coord, c in islandGeometry.coords
            miniMapCoord = @coordinateToMiniMap {x:coord.x, y:coord.y}
            islandCoords.push [miniMapCoord.x, miniMapCoord.y]
          @islandPaths.push (new Path2D Base.buildPathString(islandCoords, true))

      for islandGeometry in bckIslands.geometries
        islandCoords = []
        if islandGeometry.coords.length > 80
          for coord, c in islandGeometry.coords
            miniMapCoord = @coordinateToMiniMap {x:coord.x, y:coord.y}
            islandCoords.push [miniMapCoord.x, miniMapCoord.y]
          @islandPaths.push (new Path2D Base.buildPathString(islandCoords, true))

      return


    draw: () ->
      app.ctx.save()
      app.ctx.fillStyle = 'white'
      app.ctx.fill @path
      app.ctx.lineWidth = @lw
      app.ctx.strokeStyle = 'white'
      app.ctx.rect @x + @lw, @y + @lw, @w - 2 * @lw, @h - 2 * @lw
      app.ctx.stroke()
      app.ctx.clip()

      app.ctx.fillStyle = 'grey'

      if @islandPaths.length == 0
        @getIslandPaths()

      for islandPath in @islandPaths
        app.ctx.fill islandPath

      app.ctx.restore()

      app.ctx.stroke(@path)
      app.ctx.fillStyle = 'black'
      x1 = @dx * app.state.position.x
      y1 = @dy * app.state.position.y
      mmCoord = @coordinateToMiniMap(x: app.state.position.x, y: app.state.position.y)
      mw = @dx * app.state.view.w / app.state.zoom - 2 * @lw
      mh = @dy * app.state.view.h / app.state.zoom - 2 * @lw
      app.ctx.strokeRect mmCoord.x + @lw, mmCoord.y + @lw, mw, mh
      return

    mouseConflict: ->
      mouseX = app.state.controls.mousePosition.x
      mouseY = app.state.controls.mousePosition.y
      mouseX > @x and mouseX < @x + @w and mouseY > @y and mouseY < @y + @h

    mouseClick: ->
      mouseX = app.state.controls.mousePosition.x
      mouseY = app.state.controls.mousePosition.y

      app.setNewXPosition ((mouseX - @x)/@w * app.state.map.w) - app.state.view.w/2
      app.setNewYPosition ((mouseY - @y)/@h * app.state.map.h) - app.state.view.h/2
