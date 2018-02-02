define 'Text', ['App'], (app) ->
  class Text
    constructor: (@ctx, @id, position, @text, @style) ->
      @x = position.x
      @y = position.y

    draw: ->
      @ctx.font = @style.font
      @ctx.textAlign = @style.textAlign
      @ctx.fillText @text(), @x, @y + 8
      return
