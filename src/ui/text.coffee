define 'Text', ['App'], (app) ->
  class Text
    constructor: (@id, position, @text) ->
      @x = position.x
      @y = position.y

    draw: () ->
      app.ctx.fillText @text(), @x, @y + 8
      return
