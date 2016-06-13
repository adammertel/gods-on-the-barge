define 'GameInfo', ['Ui', 'Text', 'Button', 'Base', 'Colors', 'TextStyle', 'CultsEnum'], (Ui, Text, Button, Base, Colors, TextStyle, Cult) ->

  class GameInfo extends Ui
    constructor: ->
      @canvas = app.getCanvasById('gameinfo')
      @ctx = @canvas.ctx
      @canvas.registerDrawFunction @draw.bind(@)
      @setStyle()
      h = 180
      w = 140
      x = app.state.view.w - w
      y = 0
      super 'gameinfo', x, y, w, h

      @init()
      return

    setStyle: ->
      @ctx.lineWidth = 2
      return

    init: ->
      @registerText 'weekLabel', {x: @x + 100, y: @y + 10}, app.time.getWeekLabel, TextStyle.DT
      @registerText 'weekLabel', {x: @x + 100, y: @y + 30}, app.time.getSeasonYearLabel, TextStyle.DT
      @registerText 'moneyLabel', {x: @x + 100, y: @y + 65}, app.game.getPlayerGoldLabel, TextStyle.DT
      @buildGlassHour()

      # statistics
      @registerText 'believers', {x: @x + 45, y: @y + 90}, @mst.bind(@, 'TOTAL BELIEVERS'), TextStyle.BOLD
      x = @x + 90
      y = @y + 105
      @dtdd {x: x, y: y, id: 'os1'}, {dt: @mst.bind(@, Cult['SERAPIS']), dd: app.game.getCultBelievers.bind(@, Cult['SERAPIS'])}
      @dtdd {x: x, y: y + 15, id: 'os1'}, {dt: @mst.bind(@, Cult['ISIS']), dd: app.game.getCultBelievers.bind(@, Cult['ISIS'])}
      @dtdd {x: x, y: y + 30, id: 'os1'}, {dt: @mst.bind(@, Cult['ANUBIS']), dd: app.game.getCultBelievers.bind(@, Cult['ANUBIS'])}
      @dtdd {x: x, y: y + 45, id: 'os1'}, {dt: @mst.bind(@, Cult['BASTET']), dd: app.game.getCultBelievers.bind(@, Cult['BASTET'])}
      return

    drawCultStatHighlighters: ->
      cults = app.game.state.cults
      x = @x + 90
      y = @y + 102
      h = 13

      @ctx.fillStyle = cults[Cult['SERAPIS']].color
      @ctx.fillRect x, y, -40, h

      @ctx.fillStyle = cults[Cult['ISIS']].color
      @ctx.fillRect x, y + 15, -20, h

      @ctx.fillStyle = cults[Cult['ANUBIS']].color
      @ctx.fillRect x, y + 30, -40, h

      @ctx.fillStyle = cults[Cult['BASTET']].color
      @ctx.fillRect x, y + 45, -35, h

    buildGlassHour: ->
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

      @pathGlass = new Path2D Base.buildPathString glassCoords, true
      @pathTriangle1 = new Path2D Base.buildPathString glassWhiteTriangle1Coords, true
      @pathTriangle2 = new Path2D Base.buildPathString glassWhiteTriangle2Coords, true

      return

    drawBackground: ->
      @ctx.globalAlpha = 0.5
      @ctx.fillStyle = 'white'
      @ctx.fill @bckPath
      @ctx.globalAlpha = 1

    drawGlassHours: ->
      h = 36
      w = 20
      x1 = @x + 110
      y1 = @y + 10

      @ctx.fillStyle = Colors.SAND
      dh = h * (app.time.state.day-1)/7
      @ctx.fillRect x1, y1 + dh, w, h - dh

      @ctx.fillStyle = 'white'
      @ctx.fill @pathTriangle1
      @ctx.fill @pathTriangle2
      @ctx.stroke @pathGlass
      return

    drawCoin: ->
      @ctx.beginPath()
      @ctx.arc @x + 117, @y + 67, 7, 0, 2 * Math.PI, false
      @ctx.fillStyle = Colors.GOLD
      @ctx.stroke()
      @ctx.fill()
      @ctx.closePath()
      return

    draw: ->
      @drawCultStatHighlighters()
      if app.state.started
        super()
        @drawGlassHours()
        @drawCoin()
      return
