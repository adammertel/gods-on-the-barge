define 'Ui', ['Base', 'Button', 'Text', 'Colors', 'TextStyle', 'FontStyle'], (Base, Button, Text, Colors, TextStyle, FontStyle) ->
  class Ui
    constructor: (@id, @x, @y, @w, @h) ->
      y = @y - 1
      @bckPath = new Path2D()
      @bckPath.rect @x, y, @w, @h

      @mst = @makeStaticText
      @buttons = []
      @texts = []
      return

    dtdd: (props, dtdd) ->
      @registerText props.id + 'dt', {x: props.x , y: props.y}, dtdd.dt, TextStyle.DT
      @registerText props.id + 'dd', {x: props.x + 5, y: props.y}, dtdd.dd, TextStyle.DD
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
      #app.ctx.strokeStyle = 'black'
      app.ctx.fill @bckPath
      #app.ctx.stroke @bckPath

    drawPieChart: (segments, size, x, y) ->
      cumulativeBefore = 0
      cumulativeAfter = 0
      app.ctx.font = FontStyle.BOLDSMALL
      app.ctx.textAlign = 'left'

      for segment, s in segments
        cumulativeAfter += segment.value
        app.ctx.fillStyle = segment.color
        app.ctx.beginPath()
        app.ctx.moveTo x, y
        app.ctx.arc x, y, size, cumulativeBefore * 2 * Math.PI, cumulativeAfter * 2 * Math.PI, false
        app.ctx.lineTo x, y
        app.ctx.closePath()
        app.ctx.fill()
        cumulativeBefore += segment.value

        segnemntX = x + size + 10
        segnemntY = y + 20 - s * 13
        app.ctx.fillRect segnemntX, segnemntY - 10, 15, 10

        app.ctx.fillStyle = 'black'
        app.ctx.fillText segment.label + ': ' + Base.round(segment.value * 100) + '%', segnemntX + 20, segnemntY

    draw: ->
      app.ctx.lineWidth = 2
      @mouseConflict()

      @drawBackground()
      app.ctx.fillStyle = 'black'
      @drawTexts()
      @drawButtons()
      return
