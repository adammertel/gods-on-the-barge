define 'Menu', ['App', 'MiniMap', 'Text', 'Button'], (app, MiniMap, Text, Button) ->
  class Menu
    constructor: () ->
      @h = 150
      @w = app.state.view.w
      @x = 0
      @y = app.state.view.h - @h
      @mm = new MiniMap()
      @lw = 2
      @texts = []
      @buttons = []
      @init()
      return

    buttonStyles:
      speed:
        inactive: {stroke: 'black', fill: 'white', text: 'black', lw: 2}
        active: {stroke: 'black', fill: 'grey', text: 'black', lw: 2}

    init: () ->
      bs = _.clone @buttonStyles
      @registerText 'datum', {x: @w - @mm.w - 200, y: @h - 25 + @y}, @getDatumValue
      gameSpeed = app.state.game.time.timeSpeed

      @registerButton 'speed0', {x: @w - @mm.w - 75, y: @h - 25 + @y, w: 25, h: 25}, @makeStaticText.bind(@, '||'), @changeSpeed0.bind(@), bs['speed'], gameSpeed == 0
      @registerButton 'speed1', {x: @w - @mm.w - 50, y: @h - 25 + @y, w: 25, h: 25}, @makeStaticText.bind(@, '>'), @changeSpeed1.bind(@), bs['speed'], gameSpeed == 1
      @registerButton 'speed2', {x: @w - @mm.w - 25, y: @h - 25 + @y, w: 25, h: 25}, @makeStaticText.bind(@, '>>'), @changeSpeed2.bind(@), bs['speed'], gameSpeed == 2

      @registerButton 'zoomIn', {x: @w - @mm.w - 25, y: @h - 50 + @y, w: 25, h: 25}, @makeStaticText.bind(@, '+'), @zoomIn.bind(@), bs['speed'], gameSpeed == 2
      @registerButton 'zoomOut', {x: @w - @mm.w - 50, y: @h - 50 + @y, w: 25, h: 25}, @makeStaticText.bind(@, '-'), @zoomOut.bind(@), bs['speed'], gameSpeed == 2
      return

    changeSpeed0: () ->
      @getButton('speed0').activate()
      @getButton('speed1').deactivate()
      @getButton('speed2').deactivate()
      app.state.game.time.timeSpeed = 0
      return

    changeSpeed1: () ->
      @getButton('speed0').deactivate()
      @getButton('speed1').activate()
      @getButton('speed2').deactivate()
      app.state.game.time.timeSpeed = 1
      return

    changeSpeed2: () ->
      @getButton('speed0').deactivate()
      @getButton('speed1').deactivate()
      @getButton('speed2').activate()
      app.state.game.time.timeSpeed = 2
      return

    zoomOut: () ->
      app.zoomOut()
      return

    zoomIn: () ->
      app.zoomIn()
      return

    makeStaticText: (text) ->
      text

    getDatumValue: () ->
      'year: ' + app.state.game.time.year + ' BC, month: ' + _.floor app.state.game.time.month

    getButton: (buttonId) ->
      _.find @buttons, (button) =>
        button.id == buttonId

    draw: () ->
      _.each @buttons, (button, b) =>
        button.isClicked()

      app.ctx.lineWidth = @lw
      app.ctx.fillStyle = 'white'
      app.ctx.strokeStyle = 'black'
      app.ctx.fillRect @x, @y, @w, @h
      app.ctx.strokeRect @x + @lw/2, @y + @lw/2, @w - @lw , @h - @lw

      _.each @texts, (text, t) =>
        text.draw()

      _.each @buttons, (button, b) =>
        button.draw()

      @mm.draw()

      return

    mouseConflict: ->
      mouseX = app.state.controls.mousePosition.x
      mouseY = app.state.controls.mousePosition.y
      mouseX > @x and mouseX < @x + @w and mouseY > @y and mouseY < @y + @h

    registerText: (id, position, text)->
      @texts.push new Text(id, position, text)
      return

    registerButton: (id, position, text, action, style, active)->
      @buttons.push new Button(id, position, text, action, style, active)
      return
