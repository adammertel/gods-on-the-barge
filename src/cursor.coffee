define 'CursorControl', ['App', 'Base', 'Cursors', 'CursorDefault', 'CursorSpell'], (app, Base, Cursors, CursorDefault, CursorSpell) ->
  class CursorControl
    constructor: ->
      @cursors = []
      @init()

    init: ->
      @setCanvas()
      @registerCursor new CursorDefault(@), Cursors.DEFAULT
      @registerCursor new CursorSpell(@), Cursors.SPELL

    setCanvas: ->
      @canvas = app.getCanvasById('over')
      @ctx = @canvas.ctx
      @canvas.registerDrawFunction @draw.bind(@)

    registerCursor: (cursor, label) ->
      @cursors.push({cursor: cursor, id: label})
      return

    getActiveCursor: ->
      _.find @cursors, (cursor) =>
        cursor.id == app.state.cursor

    draw: ->
      @getActiveCursor().cursor.draw()
      return
