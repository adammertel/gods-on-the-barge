define 'Panel', ['Ui'], (Ui, Text, Panel) ->
  class CultPanel extends Ui
    constructor: (@menu, @label) ->
      @mst = @makeStaticText
      x = @menu.panelW + 2
      y = app.state.view.h - @menu.h
      w = app.state.view.w + 1 - @menu.panelW - @menu.mm.w - @menu.mmButtonSize
      h = @menu.h
      super @label, x, y, w, h

      @headerStyle = {font: 'bold 12pt Calibri', textAlign: 'left'}
      @textStyle = {font: 'bold 10pt Calibri', textAlign: 'left'}
      @init()

      return

    init: () ->
      @registerText 'label', {x: @x + 20, y: @y + 20}, @mst.bind(@, @label), @headerStyle
