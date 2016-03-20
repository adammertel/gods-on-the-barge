define 'InfoWindow', ['Base'], (Base) ->
  class InfoWindow
    constructor: (@id, position, @text, @action, @styles, @active) ->
      app.time.pause()
      @h = position.h
      @w = position.w
      @x = position.x
      @y = position.y

    close: () ->
      app.time.resume()

    draw: () ->
      @style = if @active then @styles.active else @styles.inactive
      app.ctx.lineWidth = @style.lw
