define 'InfoWindow', ['Base', 'Ui'], (Base, Ui) ->
  class InfoWindow extends Ui
    constructor: (@id, @w, @h) ->
      @ctx = app.getCanvasById('info').ctx
      super @id, (app.state.view.w - @w)/2, (app.state.view.h - @h)/2, @w, @h

      @m = 50
      @lineHeight = 20
      @lineWidth = @w - 2 * @m
      @clickableAreas = []
      return

    close: ->
      @open = false
      app.time.resume()
      return

    open: ->
      @open = true
      return

    drawBackground: ->
      @ctx.fillStyle = 'white'
      @ctx.strokeStyle = 'black'
      @ctx.fill @bckPath
      @ctx.stroke @bckPath

    draw: ->
      super()
      return
