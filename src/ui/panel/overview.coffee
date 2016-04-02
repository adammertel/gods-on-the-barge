define 'OverviewPanel', ['Base', 'Panel', 'Text', 'Button', 'ButtonStyle', 'TextStyle', 'Colors'], (Base, Panel, Text, Button, ButtonStyle, TextStyle, Colors) ->
  class OverviewPanel extends Panel
    constructor: (@menu) ->
      @label = 'Overview'
      super @menu, @label

    init: ->
      @registerText '', {x: @x + 20, y: @y + 15}, @mst.bind(@, 'GODS ON THE BARGE GAME'), TextStyle.HEADER
      @registerText '', {x: @x + 230, y: @y + 15}, @playerCultText.bind(@), TextStyle.BOLD

      # META INFO
      metaX = @x + 325
      metaY = @y + 70

      @registerButton 'ins', {x: metaX + 20, y: metaY, w: 160, h: 20}, @mst.bind(@, 'visit GEHIR project page'), @visitGehir.bind(@), ButtonStyle.NORMALINACTIVE
      @registerButton 'doc', {x: metaX + 20, y: metaY + 30, w: 160, h: 20}, @mst.bind(@, 'Game documentation'), @getGameInfo.bind(@), ButtonStyle.NORMALINACTIVE

      @registerText '', {x: metaX, y: metaY + 60}, @mst.bind(@, 'Autors: Adam Mertel, Tomáš Glomb'), TextStyle.BOLD

      # pie charts annotations
      @registerText '', {x: @x + 20, y: @y + 35}, @mst.bind(@, 'Number of islands'), TextStyle.BOLD
      @registerText '', {x: @x + 190, y: @y + 35}, @mst.bind(@, 'Total population'), TextStyle.BOLD

    playerCultText: ->
      if app.state.started
        'chosen cult ' + app.game.getPlayerCultLabel() + '. Believers: ' + app.game.state.gameStatistics.cults[app.game.getPlayerCultLabel()].total
      else
        ''

    visitGehir: ->
      Base.openWebPage 'http://gehir.phil.muni.cz'
      return

    getGameInfo: ->
      Base.openWebPage 'https://github.com/adammertel/gods_on_the_barge'
      return

    drawIslandsStatPie: ->
      pieValues = []
      cultStats = app.game.state.gameStatistics.cults
      total = 0
      for cultLabel, cult of cultStats
        total += cult.islands

      for cultLabel, cult of cultStats
        if cultLabel == 'Pagan'
          pieValues.push {'label': cultLabel, 'value': cult.islands / total, 'color': Colors['CULTPAGAN']}
        else
          pieValues.push {'label': cultLabel, 'value': cult.islands / total, 'color': app.game.state.cults[cultLabel].color}

      @drawPieChart pieValues, 35, @x + 50, @y + 100

      return

    drawTotalStatPie: ->
      pieValues = []
      cultStats = app.game.state.gameStatistics.cults
      total = 0
      for cultLabel, cult of cultStats
        total += cult.total

      for cultLabel, cult of cultStats
        if cultLabel == 'Pagan'
          pieValues.push {'label': cultLabel, 'value': cult.total / total, 'color': Colors['CULTPAGAN']}
        else
          pieValues.push {'label': cultLabel, 'value': cult.total / total, 'color': app.game.state.cults[cultLabel].color}

      @drawPieChart pieValues, 35, @x + 220, @y + 100

      return

    draw: ->
      @drawIslandsStatPie()
      @drawTotalStatPie()

      if app.state.started
        app.ctx.fillStyle = app.game.getPlayerColor()
        app.ctx.fillRect @x + 220, @y + 5, 200, 28

      super()
      return
