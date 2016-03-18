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
        speed:
          inactive: {stroke: 'black', fill: @inactiveButtonColor, text: 'black', lw: 2}
          active: {stroke: 'black', fill: @activeButtonColor, text: 'black', lw: 2}
      @init()
      return

    init: () ->
      bs = _.clone @buttonStyles
      #@registerText 'datum', {x: @w - @mm.w - 200, y: @h - 25 + @y}, app.time.getDatumLabel
      gameSpeed = app.time.state.timeSpeed

      @registerButton 'speed0', {x: @w - @mm.w - 25, y: @y + 4, w: 25, h: 25}, @makeStaticText.bind(@, '||'), @changeSpeed0.bind(@), bs['speed'], gameSpeed == 0
      @registerButton 'speed1', {x: @w - @mm.w - 25, y: @y + 29, w: 25, h: 25}, @makeStaticText.bind(@, '>'), @changeSpeed1.bind(@), bs['speed'], gameSpeed == 1
      @registerButton 'speed2', {x: @w - @mm.w - 25, y: @y + 54, w: 25, h: 25}, @makeStaticText.bind(@, '>>'), @changeSpeed2.bind(@), bs['speed'], gameSpeed == 2

      @registerButton 'zoomIn', {x: @w - @mm.w - 25, y: @h - 50 + @y, w: 25, h: 25}, @makeStaticText.bind(@, '+'), @zoomIn.bind(@), bs['speed'], gameSpeed == 2
      @registerButton 'zoomOut', {x: @w - @mm.w - 25, y: @h - 25 + @y, w: 25, h: 25}, @makeStaticText.bind(@, '-'), @zoomOut.bind(@), bs['speed'], gameSpeed == 2

      @registerPanel new OverviewPanel()
      @registerPanel new IslandsPanel()
      @registerPanel new CultPanel()
      @registerPanel new ShipsPanel()
      @activePanel = 'Overview'

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
      @activePanel

    changeSpeed0: () ->
      @getButton('speed0').activate()
      @getButton('speed1').deactivate()
      @getButton('speed2').deactivate()
      app.time.changeGameSpeed 0
      return

    changeSpeed1: () ->
      @getButton('speed0').deactivate()
      @getButton('speed1').activate()
      @getButton('speed2').deactivate()
      app.time.changeGameSpeed 1
      return

    changeSpeed2: () ->
      @getButton('speed0').deactivate()
      @getButton('speed1').deactivate()
      @getButton('speed2').activate()
      app.time.changeGameSpeed 2
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

    drawPanels: () ->
      lw = 2
      _.each @panels, (panel, p) =>
        if panel.label == @activePanel
          panel.draw
          app.ctx.fillStyle = @activeButtonColor
        else
          app.ctx.fillStyle = @inactiveButtonColor

        app.ctx.lineWidth = lw
        buttonH = (@h/@panels.length) - lw/2# + lw*@panels.length - lw

        app.ctx.fillRect lw/2, @y + lw/2 + buttonH * p, @panelW, buttonH
        app.ctx.strokeRect lw/2, @y + lw/2 + buttonH * p, @panelW, buttonH
        app.ctx.fillStyle = 'black'
        app.ctx.fillText panel.label, 10, @y + lw/2 + buttonH * p + buttonH/2

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
      @drawPanels()
      @drawButtons()

      @mm.draw()
      return

    mouseConflict: ->
      mouseX = app.state.controls.mousePosition.x
      mouseY = app.state.controls.mousePosition.y
      mouseX > @x and mouseX < @x + @w and mouseY > @y and mouseY < @y + @h
