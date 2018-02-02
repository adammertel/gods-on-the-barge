define 'Button', ['Base', 'App'], (Base, app) ->
  class Button
    constructor: (@ctx, @id, position, @text, @action, @style) ->
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
        @ctx.fillStyle = style.fill
        #@ctx.fill @buttonPath
        @ctx.fillRect @x, @y, @w, @h

      if style.stroke
        @ctx.lineWidth = 2
        #@ctx.stroke @buttonPath
        @ctx.strokeRect @x, @y, @w, @h

      @ctx.textAlign = 'center'
      @ctx.font = style.font
      @ctx.fillStyle =  style.text
      @ctx.fillText @text(), @x + @w/2, @y + @h/2 + 2

      return

    isClicked: ->
      if app.isClicked()
        mouseX = app.mouseX()
        mouseY = app.mouseY()
        if mouseX > @x and mouseX < @x + @w and mouseY > @y and mouseY < @y + @h
          app.deactivateClick()
          @action()
      return
