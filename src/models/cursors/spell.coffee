define 'CursorSpell', ['Cursor', 'Paths', 'Colors', 'CultsEnum'], (Cursor, Paths, Colors, Cult) ->
  class CursorSpell extends Cursor
    init: ->
      @path = Paths.CURSORSPELL
      @radius = 10
      @alpha = 0.2
      @radiusColor = 'white'

      super()
      return

    drawRadius: ->
      @radius = app.game.getPlayerStat('spell', 'radius')()
      @radiusColor = app.game.getPlayerStat 'spell', 'color'
      super()
      return

    drawPath: ->
      app.drawPath @ctx, @path, @mp(), 1, 0, @fillColor, @strokeWidth, @strokeColor
      return
