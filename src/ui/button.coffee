define 'Button', ['Base', 'App'], (Base, app) ->
  class Button
    constructor: (@id, position, @text, @action, @styles, @active) ->
      @h = position.h
      @w = position.w
      @x = position.x
      @y = position.y

      buttonCoords = [[@x, @y], [@x, @y + @h], [@x + @w, @y + @h], [@x + @w, @y]]
      @buttonPath = new Path2D Base.buildPathString(buttonCoords, true)

    draw: () ->
      @style = if @active then @styles.active else @styles.inactive

      app.ctx.beginPath()
      app.ctx.textAlign = 'center'
      app.ctx.font = @style.font
      app.ctx.lineWidth = 2

      if @style.fill != 'white'
        app.ctx.fillStyle = @style.fill
        app.ctx.fill @buttonPath

      if @style.stroke
        app.ctx.stroke @buttonPath
      app.ctx.fillStyle =  @style.text

      app.ctx.fillText @text(), @x + @w/2, @y + @h/2 + 2
      return

    isClicked: () ->
      if app.isClicked()
        mouseX = app.mouseX()
        mouseY = app.mouseY()
        if mouseX > @x and mouseX < @x + @w and mouseY > @y and mouseY < @y + @h
          app.deactivateClick()
          @action()
      return

    activate: () ->
      @active = true
      return

    deactivate: () ->
      @active = false
      return
