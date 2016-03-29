define 'Ui', ['Base', 'Button', 'Text', 'Colors'], (Base, Button, Text, Colors) ->
  class Ui
    constructor: (@id, @x, @y, @w, @h) ->
      y = @y - 1
      @bckPath = new Path2D()
      @bckPath.rect @x, y, @w, @h

      @buttons = []
      @texts = []
      @buttonStyle =
        inactive: {stroke: 'black', fill: Colors.BUTTONINACTIVE, text: 'black', lw: 2, font: 'bold 8pt Calibri'}
        active: {stroke: 'black', fill: Colors.BUTTONACTIVE, text: 'black', lw: 2, font: 'bold 8pt Calibri'}
        notAllowed: {stroke: 'black', fill: Colors.BUTTONNOTALLOWED, text: 'black', lw: 2, font: 'bold 8pt Calibri'}
      return

    mouseConflict: ->
      if app.isClicked()
        mouseX = app.mouseX()
        mouseY = app.mouseY()
        if mouseX > @x and mouseX < @x + @w and mouseY > @y and mouseY < @y + @h
          for button in @buttons
            button.isClicked()

          if @clickableAreas
            for area in @clickableAreas
              if mouseX > area.x and mouseX < area.x + area.w and mouseY > area.y and mouseY < area.y + area.h
                app.deactivateClick()
                area.action()
      return

    makeStaticText: (text) ->
      text

    getButton: (buttonId) ->
      _.find @buttons, (button) =>
        button.id == buttonId

    registerText: (id, position, text, font) ->
      @texts.push new Text(id, position, text, font)
      return

    registerButton: (id, position, text, action, style, active) ->
      @buttons.push new Button(id, position, text, action, style, active)
      return

    registerClickableArea: (x, y, w, h, action) ->
      @clickableAreas.push({x: x, y: y, w: w, h: h, action: action})

    drawTexts: ->
      for text in @texts
        text.draw()
      return

    drawButtons: ->
      for button in @buttons
        button.draw()
      return

    drawBackground: ->
      app.ctx.fillStyle = 'white'
      app.ctx.strokeStyle = 'black'
      app.ctx.fill @bckPath
      app.ctx.stroke @bckPath

    draw: ->
      app.ctx.lineWidth = 2
      @mouseConflict()

      @drawBackground()
      app.ctx.fillStyle = 'black'
      @drawTexts()
      @drawButtons()
      return
