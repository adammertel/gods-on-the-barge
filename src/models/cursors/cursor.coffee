define 'Cursor', [], () ->
  class Cursor
    constructor: (cursorControl) ->
      @ctx = cursorControl.ctx
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
        @ctx.globalAlpha = @alpha
        radiusPath.arc(@mp().x, @mp().y, @radius, 0, 2 * Math.PI);
        @ctx.fillStyle = @radiusColor
        @ctx.fill radiusPath
        @ctx.globalAlpha = 1
      return

    drawPath: ->
      return

    draw: ->
      @drawRadius()
      @drawPath()
      return
