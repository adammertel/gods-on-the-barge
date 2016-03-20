define 'Menu', ['App', 'MiniMap', 'Text', 'Button', 'OverviewPanel', 'IslandsPanel', 'CultPanel', 'ShipsPanel'], (app, MiniMap, Text, Button, OverviewPanel, IslandsPanel, CultPanel, ShipsPanel) ->
  class Menu
    constructor: () ->
      @h = 150
      @w = app.state.view.w
      @x = 0
      @y = app.state.view.h - @h
      @mm = new MiniMap()
      @activeButtonColor = 'grey'
      @inactiveButtonColor = 'white'
      @lw = 2
      @panelW = 80
      @texts = []
      @buttons = []
      @panels = []
      @buttonStyles =
        general:
          inactive: {stroke: 'black', fill: @inactiveButtonColor, text: 'black', lw: 2}
          active: {stroke: 'black', fill: @activeButtonColor, text: 'black', lw: 2}
      @init()
      return

    init: () ->
      bs = _.clone @buttonStyles
      #@registerText 'datum', {x: @w - @mm.w - 200, y: @h - 25 + @y}, app.time.getDatumLabel
      gameSpeed = app.time.state.timeSpeed

      @registerButton 'speed0', {x: @w - @mm.w - 25, y: @y + 4, w: 25, h: 25}, @makeStaticText.bind(@, '||'), @changeSpeed0.bind(@), bs['general'], gameSpeed == 0
      @registerButton 'speed1', {x: @w - @mm.w - 25, y: @y + 29, w: 25, h: 25}, @makeStaticText.bind(@, '>'), @changeSpeed1.bind(@), bs['general'], gameSpeed == 1
      @registerButton 'speed2', {x: @w - @mm.w - 25, y: @y + 54, w: 25, h: 25}, @makeStaticText.bind(@, '>>'), @changeSpeed2.bind(@), bs['general'], gameSpeed == 2

      @registerButton 'zoomIn', {x: @w - @mm.w - 25, y: @h - 50 + @y, w: 25, h: 25}, @makeStaticText.bind(@, '+'), @zoomIn.bind(@), bs['general'], false
      @registerButton 'zoomOut', {x: @w - @mm.w - 25, y: @h - 25 + @y, w: 25, h: 25}, @makeStaticText.bind(@, '-'), @zoomOut.bind(@), bs['general'], false

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
        @registerButton 'panel' + label, {x: lw/2, y: @y + 1.5*lw + buttonH * p, w: @panelW, h: buttonH}, @makeStaticText.bind(@, label), @changeActivePanel.bind(@, label), bs['general'], @activePanel == label

      return

    registerPanel: (panel) ->
      @panels.push panel

    registerText: (id, position, text)->
      @texts.push new Text(id, position, text)
      return

    registerButton: (id, position, text, action, style, active)->
      @buttons.push new Button(id, position, text, action, style, active)
      return

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

    makeStaticText: (text) ->
      text

    getButton: (buttonId) ->
      _.find @buttons, (button) =>
        button.id == buttonId

    drawActivePanel: () ->
      @getActivePanel().draw()
      return

    drawTexts: () ->
      _.each @texts, (text, t) =>
        text.draw()

    drawButtons: () ->
      _.each @buttons, (button, b) =>
        button.draw()

    draw: () ->
      _.each @buttons, (button, b) =>
        button.isClicked()

      app.ctx.lineWidth = @lw
      app.ctx.fillStyle = 'white'
      app.ctx.strokeStyle = 'black'
      app.ctx.fillRect @x, @y, @w, @h
      app.ctx.strokeRect @x + @lw/2, @y + @lw/2, @w - @lw , @h - @lw

      @drawTexts()
      @drawActivePanel()
      @drawButtons()

      @mm.draw()
      return

    mouseConflict: ->
      mouseX = app.state.controls.mousePosition.x
      mouseY = app.state.controls.mousePosition.y
      mouseX > @x and mouseX < @x + @w and mouseY > @y and mouseY < @y + @h
