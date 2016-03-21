define 'Text', ['App'], (app) ->
  class Text
    constructor: (@id, position, @text, @style) ->
      @x = position.x
      @y = position.y

    draw: () ->
      app.ctx.font = @style.font
      app.ctx.textAlign = @style.textAlign
      app.ctx.fillText @text(), @x, @y + 8
      return
