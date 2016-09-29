require ['Canvas', 'Time', 'Game', 'Weather', 'Base', 'Island', 'MiniMap', 'CursorControl', 'Route', 'Port', 'Ship', 'Islands',  'BackgroundIslands', 'Nodes', 'Ships', 'Storms', 'Routes', 'Menu', 'WelcomeWindow', 'PerkWindow', 'CultsEnum', 'GameInfo'], (Canvas, Time, Game, Weather, Base, Island, MiniMap, CursorControl, Route, Port, Ship, Islands, BackgroundIslands, Nodes, Ships, Storms, Routes, Menu, WelcomeWindow, PerkWindow, Cults, GameInfo) ->
  console.log 'init game'

  prepareCanvas = (canvasDivName, id, w, h, fps = 60) ->
    canvas = document.getElementById canvasDivName
    canvas.width = w
    canvas.height = h

    app.registerCanvas {id: id, ctx: ctx, w: w, h: h, fps: fps}
    return

  gameFpsRatio = 2
  defaultCanvas =
    h: app.state.menu.h - 200
    w: app.state.menu.w
    x: 0
    y: 0

  app.calculateMap()

  app.linksData = JSON.parse Base.doXhr('data/links.json').responseText

  app.registerCollection 'Nodes', 'data/nodes.json', 'nodes', defaultCanvas, 4, gameFpsRatio
  app.registerCollection 'Islands', 'data/islands.json', 'islands', defaultCanvas, 1, gameFpsRatio
  app.registerCollection 'Routes', 'data/edges.json', 'routes', defaultCanvas, 3, gameFpsRatio
  app.registerCollection 'BackgroundIslands', 'data/backgroundislands.json', 'backgroundislands', defaultCanvas, 0, gameFpsRatio
  app.registerCollection 'Storms', '', 'storms', defaultCanvas, 10, 1
  app.registerCollection 'Ships', '', 'ships', defaultCanvas, 8, 1
  app.registerCollection 'IslandLabels', '', 'islandLabels', defaultCanvas, 5, gameFpsRatio

  overCanvas = new Canvas 'over', {h: app.state.menu.h, w: app.state.menu.w, x: 0, y: 0}, 20, 1
  gameinfoCanvas = new Canvas 'gameinfo', {h: app.state.menu.h - 200, w: app.state.menu.w, x: 0, y: 0}, 15, 10
  radiusCursorCanvas = new Canvas 'cursorradius', {h: app.state.menu.h - 200, w: app.state.menu.w, x: 0, y: 0}, 30, 1
  infoCanvas = new Canvas 'info', {h: app.state.menu.h, w: app.state.menu.w, x: 0, y: 0}, 15, 10
  gameinfoCanvas.registerDrawFunction app.writeDevelInfo.bind(app, gameinfoCanvas.ctx)

  app.game = new Game()
  app.time = new Time()
  app.weather = new Weather()

  app.menu = new Menu()
  app.cursor = new CursorControl()
  app.gameInfo = new GameInfo()


  app.registerInfoWindow(new WelcomeWindow('welcome', 600, 600), true)
  app.registerInfoWindow(new PerkWindow('perks', 320, 300), false)

  app.loop()

  # MOUSE AND KEYBOARD EVENTS
  wrapper = document.getElementById 'canvases'

  wrapper.addEventListener 'mousewheel', (e) ->
    if e.deltaY < 0
      app.zoomIn()
    else
      app.zoomOut()

    return

  wrapper.addEventListener 'mousedown', (e) ->
    if !app.state.freezeMouseClicks
      if app.state.spellReady
        app.game.playerSpellCheck()

      app.state.controls.mouseClicked = true
      app.state.controls.mouseClickedPosition =
        x: e.clientX
        y: e.clientY

    return

  wrapper.addEventListener 'dblclick', (e) ->
    app.state.controls.mouseDblClicked = true
    if app.mouseOverMap()
      app.zoomIn()
    return

  wrapper.addEventListener 'mouseup', (e) ->
    app.state.controls.mouseClicked = false
    app.state.controls.mouseDblClicked = false
    app.state.controls.mapDragging = false
    return

  document.body.addEventListener 'keydown', (e) ->
    key = e.key

    if app.mouseOverMap()
      if key == 'ArrowUp'
        app.increaseYPosition -app.state.mapMoveChangeKey

      if key == 'ArrowLeft'
        app.increaseXPosition -app.state.mapMoveChangeKey

      if key == 'ArrowDown'
        app.increaseYPosition app.state.mapMoveChangeKey

      if key == 'ArrowRight'
        app.increaseXPosition app.state.mapMoveChangeKey

    return


  wrapper.addEventListener 'mousemove', (e) ->
    app.state.controls.mousePosition =
      x: e.clientX
      y: e.clientY

    if app.state.controls.mouseClicked and app.mouseOverMap() and !app.isInfoWindowOpen()
      zoom = app.state.zoom
      mcp = app.state.controls.mouseClickedPosition
      if mcp.y - (e.clientY) != 0 or mcp.x - (e.clientX) != 0
        app.setNewYPosition app.state.position.y + (mcp.y - (e.clientY)) * 1/zoom
        app.setNewXPosition app.state.position.x + (mcp.x - (e.clientX)) * 1/zoom

        app.state.controls.mapDragging = true

        app.state.controls.mouseClickedPosition =
          x: e.clientX
          y: e.clientY

    return

  wrapper.addEventListener 'mouseout', (e) ->
    app.state.controls.mouseClicked = false
    app.state.controls.mouseClickedPosition =
      x: e.clientX
      y: e.clientY
    return
