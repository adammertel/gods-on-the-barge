define 'Menu', ['Ui', 'MiniMap', 'Text', 'Button', 'OverviewPanel', 'IslandsPanel', 'CultPanel', 'ShipsPanel'], (Ui, MiniMap, Text, Button, OverviewPanel, IslandsPanel, CultPanel, ShipsPanel) ->
  class Menu extends Ui
    constructor: () ->
      h = 150
      super 'menu', 0, app.state.view.h - h, app.state.view.w, h

      @mm = new MiniMap()
      @panelW = 80

      @panels = []

      @init()
      return

    init: () ->
      bs = _.clone @buttonStyle
      #@registerText 'datum', {x: @w - @mm.w - 200, y: @h - 25 + @y}, app.time.getDatumLabel
      gameSpeed = app.time.state.timeSpeed

      @registerButton 'speed0', {x: @w - @mm.w - 25, y: @y + 4, w: 25, h: 25}, @makeStaticText.bind(@, '||'), @changeSpeed0.bind(@), bs, gameSpeed == 0
      @registerButton 'speed1', {x: @w - @mm.w - 25, y: @y + 29, w: 25, h: 25}, @makeStaticText.bind(@, '>'), @changeSpeed1.bind(@), bs, gameSpeed == 1
      @registerButton 'speed2', {x: @w - @mm.w - 25, y: @y + 54, w: 25, h: 25}, @makeStaticText.bind(@, '>>'), @changeSpeed2.bind(@), bs, gameSpeed == 2

      @registerButton 'zoomIn', {x: @w - @mm.w - 25, y: @h - 50 + @y, w: 25, h: 25}, @makeStaticText.bind(@, '+'), @zoomIn.bind(@), bs, false
      @registerButton 'zoomOut', {x: @w - @mm.w - 25, y: @h - 25 + @y, w: 25, h: 25}, @makeStaticText.bind(@, '-'), @zoomOut.bind(@), bs, false

      @registerPanel new OverviewPanel(@)
      @registerPanel new IslandsPanel(@)
      @registerPanel new CultPanel(@)
      @registerPanel new ShipsPanel(@)

      lw = 2
      buttonH = (@h/@panels.length) - 1/2# - lw/4 * @panels.length

      @activePanel = 'Overview'
      _.each @panels, (panel, p) =>
        label = panel.label
        console.log label == @activePanel
        @registerButton 'panel' + label, {x: lw/2, y: @y + 1.5*lw + buttonH * p, w: @panelW, h: buttonH}, @makeStaticText.bind(@, label), @changeActivePanel.bind(@, label), bs, @activePanel == label

      return

    registerPanel: (panel) ->
      @panels.push panel

    getActivePanel: ->
      _.find @panels, (panel) =>
        panel.label == @activePanel

    changeActivePanel: (panelLabel)->
      @activePanel = panelLabel
      self = @
      _.each @panels, (panel, p) =>
        if panel.label == self.activePanel
          self.getButton('panel' + panel.label).activate()
        else
          self.getButton('panel' + panel.label).deactivate()
      return

    changeSpeed0: () ->
      app.time.changeGameSpeed 0
      @getButton('speed0').activate()
      @getButton('speed1').deactivate()
      @getButton('speed2').deactivate()
      return

    changeSpeed1: () ->
      app.time.changeGameSpeed 1
      @getButton('speed0').deactivate()
      @getButton('speed1').activate()
      @getButton('speed2').deactivate()
      return

    changeSpeed2: () ->
      app.time.changeGameSpeed 2
      @getButton('speed0').deactivate()
      @getButton('speed1').deactivate()
      @getButton('speed2').activate()
      return

    zoomOut: () ->
      app.zoomOut()
      return

    zoomIn: () ->
      app.zoomIn()
      return

    drawActivePanel: () ->
      @getActivePanel().draw()
      return

    draw: () ->
      super()
      @drawActivePanel()
      @mm.draw()
      return
