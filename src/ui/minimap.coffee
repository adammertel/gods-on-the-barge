define 'MiniMap', ['Base', 'Canvas'], (Base, Canvas) ->
  class MiniMap
    constructor: ->
      @h = 150
      @w = app.state.map.w / (app.state.map.h - @h) * @h
      @x = app.state.view.w - @w - 1
      @y = app.state.view.h - @h - 1
      @lw = 2
      @dx = @w / app.state.map.w
      @dy = @h / (app.state.map.h - 2*@h)
      @setCanvas()

      pathCoords = [[@x, @y], [@x, @y + @h], [@x + @w, @y + @h], [@x + @w, @y]]
      @path = new Path2D Base.buildPathString(pathCoords, true)

      @getIslandPaths()
      return

    setStyle: ->
      @ctx.lineWidth = 2
      @ctx.strokeStyle = 'black'
      @ctx.fillStyle = 'grey'
      return

    setCanvas: ->
      canvas = new Canvas 'minimap',{h: @h, w: @w + 3, x: @x, y: @y}, 10, 1
      @canvas = canvas
      @ctx = canvas.ctx
      @setStyle()
      @canvas.registerDrawFunction @draw.bind(@)
      @canvas.registerFrameFunction @mouseConflict.bind(@)
      return

    coordinateToMiniMap: (c) ->
      x: Base.round((@dx * (c.x)) * 10)/10
      y: Base.round((@dy * (c.y)) * 10)/10

    getIslandPaths: ->
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

      if !@islandPathsConcated
        @getIslandPaths()


      @ctx.fill @islandPathsConcated
      return

    drawPosition: ->
      @ctx.strokeRect @x - app.menu.mmSize, @y, @w + app.menu.mmSize, @h
      x1 = @dx * app.state.position.x
      y1 = @dy * app.state.position.y

      mmCoord = @coordinateToMiniMap(x: app.state.position.x, y: app.state.position.y)
      mw = @dx * app.state.view.w / app.state.zoom - 2 * @lw
      mh = @dy * (app.state.view.h - @h) / app.state.zoom - 2 * @lw
      @ctx.strokeRect mmCoord.x + @lw, mmCoord.y + @lw, mw, mh
      return

    drawBorders: ->
      @ctx.strokeRect 1, 0, @w, @h
      return

    draw: ->
      @drawIslands()
      @drawPosition()
      @drawBorders()
      return

    mouseConflict: ->
      if app.isClicked()
        mouseX = app.mouseX()
        mouseY = app.mouseY()

        if mouseX > @x and mouseX < @x + @w and mouseY > @y and mouseY < @y + @h
          app.setNewXPosition ((mouseX - @x)/@w * app.state.map.w) - app.state.view.w/2 * 1/app.state.zoom
          app.setNewYPosition ((mouseY - @y)/@h * app.state.map.h) - app.state.view.h/2 * 1/app.state.zoom

      return
