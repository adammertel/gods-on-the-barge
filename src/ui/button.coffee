define 'Button', ['Base', 'App'], (Base, app) ->
  class Button
    constructor: (@id, position, @text, @action, @style) ->
      @h = position.h
      @w = position.w
      @x = position.x
      @y = position.y

      @buttonPath = new Path2D()
      @buttonPath.rect @x, @y, @w, @h


    draw: ->
      if typeof @style == 'function'
        style = @style()
      else
        style = @style

      if style.fill
        app.ctx.fillStyle = style.fill
        #app.ctx.fill @buttonPath
        app.ctx.fillRect @x, @y, @w, @h

      if style.stroke
        app.ctx.lineWidth = 2
        #app.ctx.stroke @buttonPath
        app.ctx.strokeRect @x, @y, @w, @h

      app.ctx.textAlign = 'center'
      app.ctx.font = style.font
      app.ctx.fillStyle =  style.text
      app.ctx.fillText @text(), @x + @w/2, @y + @h/2 + 2

      return


    isClicked: ->
      if app.isClicked()
        mouseX = app.mouseX()
        mouseY = app.mouseY()
        if mouseX > @x and mouseX < @x + @w and mouseY > @y and mouseY < @y + @h
          app.deactivateClick()
          @action()
      return
