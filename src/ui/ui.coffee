define 'Ui', ['Button', 'Text'], (Button, Text) ->
  class Ui
    constructor: (@id, @x, @y, @w, @h) ->
      @buttons = []
      @texts = []
      @buttonStyle =
        inactive: {stroke: 'black', fill: 'white', text: 'black', lw: 2, font: 'bold 8pt Calibri'}
        active: {stroke: 'black', fill: 'grey', text: 'black', lw: 2, font: 'bold 8pt Calibri'}
      return

    mouseConflict: ->
      if app.isClicked()
        mouseX = app.state.controls.mousePosition.x
        mouseY = app.state.controls.mousePosition.y
        if mouseX > @x and mouseX < @x + @w and mouseY > @y and mouseY < @y + @h
          _.each @buttons, (button, b) =>
            button.isClicked()

          _.each @clickableAreas, (area, a) =>
            if mouseX > area.x and mouseX < area.x + area.w and mouseY > area.y and mouseY < area.y + area.h
              app.deactivateClick()
              area.action()
      return

    makeStaticText: (text) ->
      text

    getButton: (buttonId) ->
      _.find @buttons, (button) =>
        button.id == buttonId

    registerText: (id, position, text)->
      @texts.push new Text(id, position, text)
      return

    registerButton: (id, position, text, action, style, active)->
      @buttons.push new Button(id, position, text, action, style, active)
      return

    registerClickableArea: (x, y, w, h, action) ->
      @clickableAreas.push({x: x, y: y, w: w, h: h, action: action})

    drawTexts: () ->
      _.each @texts, (text, t) =>
        text.draw()
      return

    drawButtons: () ->
      _.each @buttons, (button, b) =>
        button.draw()
      return

    drawBackground: () ->
      m = 2
      app.ctx.lineWidth = 2
      app.ctx.fillStyle = 'white'
      app.ctx.fillRect @x - m/2, @y, @w - m/2, @h - m/2
      app.ctx.strokeStyle = 'black'
      app.ctx.strokeRect @x - m/2, @y, @w - m/2, @h - m/2

    draw: () ->
      app.ctx.lineWidth = 2
      @mouseConflict()

      @drawBackground()
      app.ctx.fillStyle = 'black'
      @drawTexts()
      @drawButtons()
      return
