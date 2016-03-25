define 'GameInfo', ['Ui', 'Text', 'Button', 'Base'], (Ui, Text, Button, Base) ->

  class GameInfo extends Ui
    constructor: () ->
      h = 80
      w = 140
      x = app.state.view.w - w
      y = 0
      super 'gameinfo', x, y, w, h

      @init()
      return

    init: ->
      @textStyle = {font: 'bold 9pt Calibri', textAlign: 'right'}
      @registerText 'weekLabel', {x: @x + 100, y: @y + 10}, app.time.getWeekLabel, @textStyle
      @registerText 'weekLabel', {x: @x + 100, y: @y + 30}, app.time.getSeasonYearLabel, @textStyle
      @buildGlassHour()

      @registerText 'moneyLabel', {x: @x + 100, y: @y + 65}, app.game.getPlayerMoney, @textStyle

      return

    buildGlassHour: () ->
      h = 36
      w = 20
      d = 6
      x1 = @x + 110
      x2 = x1 + w
      y1 = @y + 10
      y2 = y1 + h

      xc1 = x1 + (w/2 - d/2)
      xc2 = x1 + (w/2 + d/2)
      yc = y1 + h/2

      glassCoords = [[x1, y1], [xc1, yc], [x1, y2], [x2, y2], [xc2, yc], [x2, y1]]
      glassWhiteTriangle1Coords = [[x1, y1], [xc1, yc], [x1, y2]]
      glassWhiteTriangle2Coords = [[x2, y1], [xc2, yc], [x2, y2]]

      @pathGlass = new Path2D(Base.buildPathString glassCoords, true)
      @pathTriangle1 = new Path2D(Base.buildPathString glassWhiteTriangle1Coords, true)
      @pathTriangle2 = new Path2D(Base.buildPathString glassWhiteTriangle2Coords, true)

      return

    drawBackground: ->
      app.ctx.fillStyle = 'white'
      app.ctx.fill @bckPath

    drawGlassHours: ->
      h = 36
      w = 20
      x1 = @x + 110
      y1 = @y + 10

      app.ctx.fillStyle = 'orange'
      dh = h * (app.time.state.day-1)/7
      app.ctx.fillRect x1, y1 + dh, w, h - dh

      app.ctx.lineWidth = 2
      app.ctx.fillStyle = 'white'
      app.ctx.fill @pathTriangle1
      app.ctx.fill @pathTriangle2
      app.ctx.stroke @pathGlass
      return

    drawCoin: ->
        app.ctx.beginPath()
        app.ctx.arc @x + 90, @y + 70, 10, 0, 2 * Math.PI, false
        app.ctx.fillStyle = 'gold'
        app.ctx.fill()
        app.ctx.stroke()
        app.ctx.closePath()
        return

    draw: ->
      if app.state.started
        super()
        @drawGlassHours()
        @drawCoin()
        console.log 'started'
      return
