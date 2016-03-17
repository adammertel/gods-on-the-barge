define 'Button', ['App'], (app) ->
  class Button
    constructor: (@id, position, @text, @action, @styles, @active) ->
      @h = position.h
      @w = position.w
      @x = position.x
      @y = position.y

    draw: () ->
      @style = if @active then @styles.active else @styles.inactive
      app.ctx.lineWidth = @style.lw
      app.ctx.fillStyle = @style.fill
      app.ctx.font = 'bold 8pt Calibri'
      app.ctx.fillRect @x, @y - @style.lw, @w, @h
      app.ctx.strokeRect @x, @y - @style.lw, @w, @h
      app.ctx.fillStyle =  @style.text
      app.ctx.fillText @text(), @x + 8, @y + 16
      return

    isClicked: () ->
      if @action and app.state.controls.mouseClicked
        mouseX = app.state.controls.mousePosition.x
        mouseY = app.state.controls.mousePosition.y
        if mouseX > @x and mouseX < @x + @w and mouseY > @y and mouseY < @y + @h
          @action()
      return

    activate: () ->
      @active = true
      return

    deactivate: () ->
      @active = false
      return
