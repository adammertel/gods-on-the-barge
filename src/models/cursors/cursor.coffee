define 'Cursor', [], () ->
  class Cursor
    constructor: (cursorControl) ->
      @ctx = cursorControl.ctx
      @radiusCtx = app.getCanvasById('cursorradius').ctx
      @radius = false
      @alpha = 1
      @radiusColor = 'black'
      @init()
      return

    init: ->
      @fillColor = 'black'
      @strokeWidth = 1
      @strokeWidth = @strokeColor
      return

    mp: ->
      app.state.controls.mousePosition

    drawRadius: ->
      if @radius
        radiusPath = new Path2D()
        @radiusCtx.globalAlpha = @alpha
        radiusPath.arc(@mp().x, @mp().y, @radius * app.state.zoom, 0, 2 * Math.PI);
        @radiusCtx.fillStyle = @radiusColor
        @radiusCtx.fill radiusPath
        @radiusCtx.globalAlpha = 1
      return

    drawPath: ->
      return

    draw: ->
      @drawRadius()
      @drawPath()
      return
