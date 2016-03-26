define 'Panel', ['Ui'], (Ui, Text, Panel) ->
  class Panel extends Ui
    constructor: (@menu, @label) ->
      @mst = @makeStaticText
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

    dtdd: (props, dtdd) ->
      @registerText props.id + 'dt', {x: props.x , y: props.y}, dtdd.dt, @dtTextStyle
      @registerText props.id + 'dd', {x: props.x + 5, y: props.y}, dtdd.dd, @ddTextStyle
      return

    init: ->
      @registerText 'label', {x: @x + 20, y: @y + 20}, @mst.bind(@, @label), @headerStyle
