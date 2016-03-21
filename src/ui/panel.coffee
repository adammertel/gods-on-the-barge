define 'Panel', ['Ui'], (Ui, Text, Panel) ->
  class CultPanel extends Ui
    constructor: (@menu, @label) ->
      x = @menu.panelW + 2
      y = app.state.view.h - @menu.h
      w = app.state.view.w + 1 - @menu.panelW - @menu.mm.w - @menu.mmButtonSize
      h = @menu.h
      super @label, x, y, w, h
      return
