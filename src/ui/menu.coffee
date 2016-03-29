define 'Menu', ['Ui', 'MiniMap', 'Text', 'Button', 'OverviewPanel', 'IslandsPanel', 'CultPanel', 'ShipsPanel', 'PoliticsPanel', 'WeatherPanel', 'TextStyle', 'ButtonStyle'], (Ui, MiniMap, Text, Button, OverviewPanel, IslandsPanel, CultPanel, ShipsPanel, PoliticsPanel, WeatherPanel, TextStyle, ButtonStyle) ->
  class Menu extends Ui
    constructor: ->
      h = 150
      super 'menu', 0, app.state.view.h - h, app.state.view.w, h
      @mm = new MiniMap()
      @mmButtonSize = @h/6 - 2
      @panelW = 80
      @panels = []

      @init()
      return

    init: ->
      @bs = _.clone @buttonStyle
      gameSpeed = app.time.state.timeSpeed

      s = @mmButtonSize + 2
      m = 2
      x =  @w - @mm.w - s
      y = @y
      @registerButton 'speed0', {x: x, y: y, w: s, h: @mmButtonSize}, @mst.bind(@, '||'), @changeSpeed.bind(@, 0), @speedButtonStyle.bind(@, 0)
      @registerButton 'speed1', {x: x, y: y + 1*s, w: s, h: @mmButtonSize}, @mst.bind(@, '>'), @changeSpeed.bind(@, 1), @speedButtonStyle.bind(@, 1)
      @registerButton 'speed2', {x: x, y: y + 2*s, w: s, h: @mmButtonSize}, @mst.bind(@, '>>'), @changeSpeed.bind(@, 2), @speedButtonStyle.bind(@, 2)
      @registerButton 'speed3', {x: x, y: y + 3*s, w: s, h: @mmButtonSize}, @mst.bind(@, '>>>'), @changeSpeed.bind(@, 10), @speedButtonStyle.bind(@, 10)

      @registerButton 'zoomIn', {x: x, y: y + 4*s, w: s, h: @mmButtonSize}, @mst.bind(@, '+'), @zoomIn.bind(@), ButtonStyle.MENUINACTIVE
      @registerButton 'zoomOut', {x: x, y: y + 5*s, w: s, h: @mmButtonSize}, @mst.bind(@, '-'), @zoomOut.bind(@), ButtonStyle.MENUINACTIVE

      @registerPanel new OverviewPanel(@)
      @registerPanel new IslandsPanel(@)
      @registerPanel new ShipsPanel(@)
      @registerPanel new PoliticsPanel(@)
      @registerPanel new WeatherPanel(@)
      @registerPanel new CultPanel(@)


      lw = 2
      buttonH = @h/@panels.length# - lw/4 * @panels.length
      @activePanel = 'Overview'

      for panel, p in @panels
        label = panel.label
        @registerButton 'panel' + label, {x: 0, y: @y + buttonH * p - 1, w: @panelW + 2, h: buttonH}, @mst.bind(@, _.upperCase label), @changeActivePanel.bind(@, label), @panelStyle.bind(@, label)

      return


    speedButtonStyle: (speed) ->
      if app.time.state.timeSpeed == speed
        ButtonStyle.MENUACTIVE
      else
        ButtonStyle.MENUINACTIVE

    panelStyle: (panel)->
      if @activePanel == panel
        ButtonStyle.MENUACTIVE
      else
        ButtonStyle.MENUINACTIVE

    registerPanel: (panel) ->
      @panels.push panel

    getActivePanel: ->
      _.find @panels, (panel) =>
        panel.id == @activePanel

    changeActivePanel: (panelLabel)->
      @activePanel = panelLabel

      if panelLabel != 'Islands'
        app.getCollection('islands').deactivateIslands()
      else
        @getActivePanel().changeToOverviewMode()

      return

    changeSpeed: (speed) ->
      app.time.changeGameSpeed speed
      return

    zoomOut: ->
      app.zoomOut()
      return

    zoomIn: ->
      app.zoomIn()
      return

    drawActivePanel: ->
      @getActivePanel().draw()
      return

    drawBackground: ->
      app.ctx.fillStyle = 'white'
      app.ctx.fill @bckPath

    strokeBackground: ->
      app.ctx.strokeStyle = 'black'
      app.ctx.strokeRect @x+1, @y-1, @w, @h
      app.ctx.strokeRect @x+1, @y-1, @panelW, @h

    draw: ->
      super()
      @drawActivePanel()
      @mm.draw()
      @strokeBackground()
      return
