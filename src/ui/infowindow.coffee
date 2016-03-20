define 'InfoWindow', ['Base'], (Base) ->
  class InfoWindow
    constructor: (@id, @w, @h) ->
      app.time.pause()
      @x = (app.state.view.w - @w)/2
      @y = (app.state.view.h - @h)/2
      @m = 50
      @lineHeight = 20
      @lineWidth = @w - 2 * @m
      @clickableAreas = []
      return

    close: () ->
      @open = false
      app.time.resume()
      return

    open: () ->
      @open = true
      return

    addClickableArea: (x, y, w, h, action) ->
      @clickableAreas.push({x: x, y: y, w: w, h: h, action: action})

    isClicked: () ->
      mouseX = app.state.controls.mousePosition.x
      mouseY = app.state.controls.mousePosition.y
      _.each @clickableAreas, (area, a) =>
        if mouseX > area.x and mouseX < area.x + area.w and mouseY > area.y and mouseY < area.y + area.h
          area.action()
      return

    draw: () ->
      if app.state.mouseClicked
        @isClicked()

      app.ctx.strokeStyle = 'black'
      app.ctx.strokeRect @x, @y, @w, @h
      app.ctx.fillStyle = 'white'
      app.ctx.fillRect @x, @y, @w, @h
