define 'OverviewPanel', ['Base', 'Panel', 'Text', 'Button', 'ButtonStyle', 'TextStyle'], (Base, Panel, Text, Button, ButtonStyle, TextStyle) ->
  class OverviewPanel extends Panel
    constructor: (@menu) ->
      @label = 'Overview'
      super @menu, @label

    init: ->
      @registerText '', {x: @x + 20, y: @y + 15}, @mst.bind(@, 'GODS ON THE BARGE GAME'), TextStyle.HEADER

      # META INFO
      metaX = @x + 325
      metaY = @y + 70

      @registerButton 'ins', {x: metaX, y: metaY, w: 180, h: 20}, @mst.bind(@, 'visit GEHIR project page'), @visitGehir.bind(@), ButtonStyle.NORMALINACTIVE
      @registerButton 'doc', {x: metaX, y: metaY + 30, w: 180, h: 20}, @mst.bind(@, 'Game documentation'), @getGameInfo.bind(@), ButtonStyle.NORMALINACTIVE

      @registerText '', {x: metaX, y: metaY + 60}, @mst.bind(@, 'Autors: Adam Mertel, Tomáš Glomb'), TextStyle.BOLD



    visitGehir: ->
      Base.openWebPage 'http://gehir.phil.muni.cz'
      return

    getGameInfo: ->
      Base.openWebPage 'https://github.com/adammertel/gods_on_the_barge'
      return

    draw: ->
      super()
      return
