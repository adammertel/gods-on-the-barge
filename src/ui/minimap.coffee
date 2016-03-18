define 'MiniMap', ['App'], (app) ->
  class MiniMap
    constructor: () ->
      @h = 150
      @w = app.state.map.w / app.state.map.h * @h
      @x = app.state.view.w - (@w)
      @y = app.state.view.h - (@h)
      @lw = 2
      @dx = @w / app.state.map.w
      @dy = @h / app.state.map.h
      return

    coordinateToMiniMap: (c) ->
      {x: @x + @dx * c.x, y: @y + @dy * c.y}

    draw: () ->
      app.ctx.save()
      app.ctx.fillStyle = 'white'
      app.ctx.fillRect @x, @y, @w, @h
      app.ctx.lineWidth = @lw
      app.ctx.strokeStyle = 'black'

      app.ctx.beginPath();
      app.ctx.moveTo @x, @y
      app.ctx.lineTo @x + @w, @y
      app.ctx.lineTo @x + @w, @y + @h
      app.ctx.lineTo @x, @y + @h
      app.ctx.closePath()

      app.ctx.clip()

      islands = app.getCollection 'islands'

      _.each islands.geometries, (islandGeometry) =>
        app.ctx.fillStyle = 'grey'
        app.ctx.beginPath()
        _.each islandGeometry.coords, (coord, c) =>
          mmCoord = @coordinateToMiniMap {x:coord.x, y:coord.y}
          if c == 0
            app.ctx.moveTo mmCoord.x, mmCoord.y
          else
            app.ctx.lineTo mmCoord.x, mmCoord.y

        app.ctx.closePath()
        app.ctx.fill()

      app.ctx.restore()
      app.ctx.strokeRect @x + @lw/2, @y + @lw/2, @w - @lw, @h - @lw
      app.ctx.fillStyle = 'grey'
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
