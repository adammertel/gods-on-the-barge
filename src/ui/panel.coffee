define 'Panel', ['Ui', 'TextStyle'], (Ui, TextStyle) ->
  class Panel extends Ui
    constructor: (@menu, @label) ->
      x = @menu.panelW + 2
      y = app.state.view.h - @menu.h
      w = app.state.view.w + 1 - @menu.panelW - @menu.mm.w - @menu.mmButtonSize
      h = @menu.h
      super @label, x, y, w, h

      @headerStyle = {font: 'bold 12pt Calibri', textAlign: 'left'}
      @boldTextStyle = {font: 'bold 9pt Calibri', textAlign: 'left'}
      @normalTextStyle = {font: '9pt Calibri', textAlign: 'left'}
      @dtTextStyle = {font: 'bold 9pt Calibri', textAlign: 'right'}
      @ddTextStyle = {font: '9pt Calibri', textAlign: 'left'}
      @init()
      return

    drawBackground: ->
      return

    init: ->
      @registerText 'label', {x: @x + 20, y: @y + 20}, @mst.bind(@, @label), TextStyle.HEADER
