define 'CursorSpell', ['Cursor', 'Paths'], (Cursor, Paths) ->
  class CursorSpell extends Cursor
    init: ->
      @path = Paths.CURSORSPELL
      @radius = 20
      @alpha = 0.2
      @radiusColor = 'red'
      super()
      return

    drawRadius: ->
      super()
      return

    drawPath: ->
      app.drawPath @ctx, @path, @mp(), 1, 0, @fillColor, @strokeWidth, @strokeColor
      return
