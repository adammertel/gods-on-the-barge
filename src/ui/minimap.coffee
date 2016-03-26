define 'MiniMap', ['Base'], (Base) ->
  class MiniMap
    constructor: ->
      @h = 150
      @w = app.state.map.w / (app.state.map.h - @h) * @h
      @x = app.state.view.w - @w - 1
      @y = app.state.view.h - @h - 1
      @lw = 2
      @dx = @w / app.state.map.w
      @dy = @h / (app.state.map.h - 2*@h)

      pathCoords = [[@x, @y], [@x, @y + @h], [@x + @w, @y + @h], [@x + @w, @y]]
      @path = new Path2D Base.buildPathString(pathCoords, true)

      @getIslandPaths()
      return

    coordinateToMiniMap: (c) ->
      x: Base.round((@x + @dx * (c.x)) * 10)/10
      y: Base.round((@y + @dy * (c.y)) * 10)/10

    getIslandPaths:() ->
      islandPaths = []
      islands = app.getCollection 'islands'
      bckIslands = app.getCollection 'backgroundIslands'

      for islandGeometry in islands.geometries
        islandCoords = []
        for coord, c in islandGeometry.coords
          miniMapCoord = @coordinateToMiniMap {x:coord.x, y:coord.y}
          islandCoords.push [miniMapCoord.x, miniMapCoord.y]
        islandPaths.push(Base.buildPathString(islandCoords, true))

      for islandGeometry in bckIslands.geometries
        islandCoords = []
        if islandGeometry.coords.length > 50
          for coord, c in islandGeometry.coords
            miniMapCoord = @coordinateToMiniMap {x:coord.x, y:coord.y}
            islandCoords.push [miniMapCoord.x, miniMapCoord.y]
          islandPaths.push(Base.buildPathString(islandCoords, true))

      @islandPathsConcated = new Path2D Base.concatPathStrings islandPaths
      return

    drawIslands: ->
      app.ctx.strokeStyle = 'white'
      app.ctx.save()
      app.ctx.rect @x + @lw/2, @y + @lw/2, @w - @lw, @h - @lw
      app.ctx.stroke()
      app.ctx.clip()

      app.ctx.fillStyle = 'grey'

      if !@islandPathsConcated
        @getIslandPaths()

      app.ctx.fill @islandPathsConcated
      app.ctx.restore()
      return

    drawPosition: ->
      app.ctx.lineWidth = 2
      app.ctx.strokeStyle = 'black'
      app.ctx.stroke(@path)
      x1 = @dx * app.state.position.x
      y1 = @dy * app.state.position.y

      mmCoord = @coordinateToMiniMap(x: app.state.position.x, y: app.state.position.y)
      mw = @dx * app.state.view.w / app.state.zoom - 2 * @lw
      mh = @dy * (app.state.view.h - @h) / app.state.zoom - 2 * @lw
      app.ctx.strokeRect mmCoord.x + @lw, mmCoord.y + @lw, mw, mh
      return

    draw: ->
      app.ctx.lineWidth = 1
      app.ctx.fillStyle = 'white'
      app.ctx.fill @path


      @drawIslands()
      @drawPosition()
      return

    mouseConflict: ->
      mouseX = app.mouseX()
      mouseY = app.mouseY()
      mouseX > @x and mouseX < @x + @w and mouseY > @y and mouseY < @y + @h

    mouseClick: ->
      mouseX = app.mouseX()
      mouseY = app.mouseY()

      app.setNewXPosition ((mouseX - @x)/@w * app.state.map.w) - app.state.view.w/2
      app.setNewYPosition ((mouseY - @y)/@h * app.state.map.h) - app.state.view.h/2
