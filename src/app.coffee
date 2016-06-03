define 'App', ['Base', 'Canvas', 'Ship', 'Season', 'Ai', 'Islands', 'IslandLabels', 'Nodes', 'Routes', 'Ships', 'Storms', 'BackgroundIslands', 'Cursors', 'Paths'], (Base, Canvas, Ship, Season, Ai, Islands, IslandLabels, Nodes, Routes, Ships, Storms, BackgroundIslands, Cursors, Paths) ->
  window.app =
    state:
      cursor: Cursors.SPELL
      loopNo: 0
      started: false
      fps: []
      lastTimeLoop: null
      view:
        h: 650
        w: 800
      menu:
        h: 700
        w: 800
      map:
        h: 0
        w: 0
      zoom: 0.5
      zoomStep: 0.1
      minZoom: 0.4
      maxZoom: 2
      position:
        x: 0
        y: 300
      controls:
        up: false
        down: false
        right: false
        left: false
        mouseClicked: false
        mouseDblClicked: false
        mouseClickedPosition: {}
        mousePosition: {}
        mapDragging: false
      pxDensity: 400
      boundingCoordinates:
        n: 39
        s: 30
        e: 32
        w: 22

    dayActions: []
    weekActions: []
    seasonActions: []
    yearActions: []

    collections: []
    infoWindows: []
    startGameFunctions: []
    ais: []
    canvases: []

    draw: ->
      for canvas in @orderedCanvases
        if !(@state.loopNo % canvas.fps)
          canvas.render()
        canvas.frame()

      @drawBorders()
      #@gameInfo.draw()
      return

    loop: ->
      app.state.loopNo += 1
      app.time.nextTick()
      app.countFps()
      app.draw()
      #app.checkPosition()

      window.requestAnimationFrame app.loop
      return

    registerCanvas: (canvas) ->
      @canvases.push(canvas)
      @orderCanvases()
      return

    orderCanvases: ->
      @orderedCanvases = _.orderBy(@canvases, 'z', 'desc')
      return

    getCanvasById: (id) ->
      foundCanvas = false
      for canvas in @canvases
        if canvas.id == id
          foundCanvas = canvas
      foundCanvas

    registerCollection: (collectionClassName, pathToData, canvasId, props, z, fps) ->
      data = @getDataFromPath pathToData

      collection = new (eval(collectionClassName))(data)
      collectionCanvas = new Canvas canvasId, props, z, fps

      collection.setCanvas collectionCanvas
      @collections.push {'collection': collection}
      collection.registerGeometries()

      return

    mouseX: ->
      @state.controls.mousePosition.x

    mouseY: ->
      @state.controls.mousePosition.y

    drawPath: (ctx, path, coords, size, rotation, fillStyle, lineWidth, strokeStyle) ->
      ctx.translate coords.x, coords.y
      if rotation
        ctx.rotate rotation
      if size != 1
        ctx.scale size, size

      if fillStyle
        ctx.fillStyle = fillStyle
        ctx.fill path
      if lineWidth or strokeStyle
        ctx.lineWidth = lineWidth
        ctx.strokeStyle = strokeStyle
        ctx.stroke path

      if rotation
        ctx.rotate -rotation
      if size != 1
        ctx.scale 1/size, 1/size
      ctx.translate -coords.x, -coords.y
      return

    drawShip: (ctx, coords, size, rotation, color) ->
      @drawPath ctx, Paths.SHIP, coords, size, rotation, color, 3, 'black'
      return

    deactivateClick: ->
      @state.controls.mouseClicked = false
      return

    isClickedMap: ->
      @isClicked() and @mouseY() < @menu.y

    isClicked: ->
      @state.controls.mouseClicked

    isMapDragging: ->
      @state.controls.mapDragging

    # functions that need to wait untill player chooses his cult
    registerStartGameFunction: (startGameFunction) ->
      @startGameFunctions.push startGameFunction
      return

    startGame: (cult) ->
      @state.started = true
      @game.chooseCult cult
      for startGameFunction in @startGameFunctions
        startGameFunction()

      @time.resume()
      @createAis()
      return

    createAis: ->
      for cult of app.game.state.cults
        if cult != app.game.getPlayerCultLabel()
          @ais.push new Ai cult

    registerInfoWindow: (infoWindow, open) ->
      @infoWindows.push infoWindow
      if open
        infoWindow.open()
      return

    getInfoWindow: (id) ->
      _.find @infoWindows, (infoWindow) =>
        infoWindow.id == id

    isInfoWindowOpen: ->
      open = false
      for infoWindow in @infoWindows
        if infoWindow.open
          open = true
      open

    drawInfoWindows: ->
      for infoWindow in @infoWindows
        if infoWindow.open
          infoWindow.draw()
      return


    # CURSOR
    changeCursor: (newCursorType) ->
      @state.cursor = newCursorType
      return


    # LINKS, PATHS, NODES
    getPathWithCheckPoints: (from, to, checkPoints) ->
      path = []
      if checkPoints.length == 0
        path = @getPath(from, to)
      else
        path = @getPath(from, checkPoints[0])
        for checkPoint, p in checkPoints
          if _.isNumber path[p+1]
            path = _.concat path, @getPath(checkPoints[p], checkPoints[p+1])
        path = _.concat path, @getPath(checkPoints[checkPoints.length-1], to)

      isNumber = (id) ->
        !isNaN id

      path.filter isNumber

    getPath: (from, to) ->
      alt1 = from + '-' + to
      alt2 = to + '-' + from
      path = []

      if @linksData[alt1]
        path = _.clone @linksData[alt1]
      else if @linksData[alt2]
        pathData = _.clone @linksData[alt2]
        path = _.reverse pathData
      path.push parseInt to
      path

    getDistanceOfNodes: (from, to) ->
      distance = 0
      path = @getPath(from, to)
      path.unshift(from)

      for node, n in path
        if typeof path[n+1] != 'undefined'
          thisNode = node
          nextNode = path[n+1]
          distance += @getCollection('routes').getDistanceOfEdge(thisNode, nextNode)

      distance

    getDataFromPath: (path) ->
      data = []
      if path
        data = JSON.parse Base.doXhr(path).responseText
      data

    getCollection: (collectionName) ->
      foundCollection = false
      for collection in @collections
        if collection.collection.name == collectionName
          foundCollection = collection.collection
      foundCollection

    drawTextArea: (ctx, text, x, y, lineHeight, lineWidth, font) ->
      ctx.font = font
      ctx.fillStyle = 'black'
      texts = Base.wrapText(ctx, text, lineWidth)

      for text, t in texts
        ctx.fillText text, x, y + t * lineHeight
      return


    # TIME
    registerNewDayAction: (action)->
      @dayActions.push action
      return

    registerNewWeekAction: (action)->
      @weekActions.push action
      return

    registerNewSeasonAction: (action)->
      @seasonActions.push action
      return

    registerNewYearAction: (action)->
      @yearActions.push action
      return

    newDay: ->
      for action in @dayActions
        action()
      #console.log 'newDay'
      return

    newWeek: ->
      for action in @weekActions
        action()
      return

    newSeason: (newSeason)->
      for action in @seasonActions
        action()
      return

    newYear: ->
      for action in @yearActions
        action()
      return

    countFps: ->
      now = new Date()
      nowValue = now.valueOf()
      app.state.fps.push parseInt(1/(nowValue - app.state.lastTimeLoop) * 1000)
      app.state.fps = _.takeRight app.state.fps, 30
      app.state.lastTimeLoop = nowValue
      return

    calculateMap: ->
      c = @state.boundingCoordinates
      @state.map.h = (c.n - c.s) * @state.pxDensity
      @state.map.w = (c.e - c.w) * @state.pxDensity
      @state.pxkm = @state.pxDensity/110
      return

    goTo: (coordinate) ->
      @state.position.x = coordinate.x
      @state.position.y = coordinate.y
      return

    writeDevelInfo: (ctx) ->
      ctx.textAlign = 'left'
      ctx.fillStyle = 'black'
      ctx.font = '10pt Calibri'
      ctx.fillText 'x: ' + Base.round(@state.position.x) + ' y: ' + Base.round(@state.position.y) + ' zoom: ' + Base.round(@state.zoom * 10)/10, 10, 10
      ctx.fillText 'fps : ' + parseInt(_.mean(@state.fps)), 10, 40
      return

    getClicked: ()->
      clicked = falsecd
      for g in @state.geometries
        if g.isClicked()
          clicked = g
      clicked

    getMousePosition: ->
      {x: @state.position.x, y: @state.position.y}

    isPointVisible: (point) ->
      point.x < @state.view.w and point.x > 0 and point.y < @state.view.h and point.y > 0

    drawBorders: ->
      #@ctx.lineWidth = 5
      #@ctx.strokeStyle = 'black'
      #@ctx.strokeRect (0 - (@state.position.x)) * @state.zoom, (0 - (@state.position.y)) * @state.zoom, @state.map.w * @state.zoom, @state.map.h * @state.zoom
      # @ctx.lineWidth = 5
      # @ctx.strokeStyle = 'black'
      # @ctx.strokeRect 0, 0, @state.view.w, @state.view.h
      return

    coordinateToMap: (c) ->
      x: Base.round((c.lon - @state.boundingCoordinates.w) * @state.pxDensity)
      y: Base.round(@state.map.h - (c.lat - @state.boundingCoordinates.s) * @state.pxDensity)

    pointToUTM: (point) ->

    coordinatesToView: (coords) ->
      for coord in coords
        @coordinateToView coord

    coordinateToView: (c) ->
      x: Base.round((c.x - @state.position.x) * @state.zoom)
      y: Base.round((c.y - @state.position.y) * @state.zoom)

    checkPosition: ->
      step = 5
      p = @state.position
      if @state.controls.left
        app.setNewXPosition p.x - step
      if @state.controls.up
        app.setNewYPosition p.y - step
      if @state.controls.right
        app.setNewXPosition p.x + step
      if @state.controls.down
        app.setNewYPosition p.y + step
      return

    setNewXPosition: (newX) ->
      @state.position.x = _.clamp(newX, 0, @state.map.w - (@state.view.w / @state.zoom))
      return

    setNewYPosition: (newY) ->
      @state.position.y = _.clamp(newY, 0, @state.map.h - (@state.view.h / @state.zoom))
      return

    mouseOverMap: ->
      !@menu.mouseConflict() and app.mouseY() < @menu.y

    zoomIn: ->
      if @state.zoom < @state.maxZoom
        w = @state.view.w
        h = @state.view.h
        s = @state.zoomStep
        z = @state.zoom
        @setNewXPosition @state.position.x + (w / z - (w / (z + s))) / 2
        @setNewYPosition @state.position.y + (w / z - (w / (z + s))) / 2
        @state.zoom = @state.zoom + s
      return

    zoomOut: ->
      if @state.zoom > @state.minZoom
        w = @state.view.w
        h = @state.view.h
        s = @state.zoomStep
        z = @state.zoom
        @setNewXPosition @state.position.x + (w / z - (w / (z - s))) / 2
        @setNewYPosition @state.position.y + (w / z - (w / (z - s))) / 2
        @state.zoom = @state.zoom - s
      return

    # PERKS
    openPerkWindow: (perks) ->
      @getInfoWindow('perks').newPerks(perks)
      return
