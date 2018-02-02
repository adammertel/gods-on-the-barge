define 'CursorDefault', ['Cursor', 'Paths'], (Cursor, Paths) ->
  class CursorDefault extends Cursor
    init: ->
      @path = Paths.CURSORDEFAULT
      super()
      return

    drawPath: ->
      app.drawPath @ctx, @path, @mp(), 1, 0, @fillColor, @strokeWidth, @strokeColor
      return
