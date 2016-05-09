define 'PerkWindow', ['InfoWindow', 'Button', 'Base', 'Colors', 'TextStyle', 'ButtonStyle', 'FontStyle'], (InfoWindow, Button, Base, Colors, TextStyle, ButtonStyle, FontStyle) ->
  class PerkWindow extends InfoWindow

    constructor: (id, w, h) ->
      super id, w, h
      @open = false
      return

    init: ->
      @registerText '', {x: @x + @m, y: @y + @m, w: 120, h: 40}, @mst.bind(@, 'CHOOSE NEW PERK'), TextStyle.HEADER

      x = @x + @m
      y = @y + @m + 50
      console.log @perks

      for perk, p in @perks
        @registerButton '', {x: x, y: y, w: 200, h: 40}, @perkButtonText.bind(@, p), @choosePerk.bind(@, p), ButtonStyle.NORMALINACTIVE
        @registerText '', {x: x, y: y + 50, w: 120, h: 40}, @perkText.bind(@, p), TextStyle.NORMAL

        y += 100

    newPerks: (newPerks) ->
      app.time.pause()
      @perks = newPerks
      @texts = []
      @buttons = []
      @init()
      @open = true
      return

    choosePerk: (perkId) ->
      console.log 'perk chosen', perkId
      app.game.applyPerkToPlayer(@perks[parseInt(perkId)])
      @cloes()
      return

    perkText: (perkId) ->
      @perks[perkId].text

    perkButtonText: (perkId) ->
      _.upperCase @perks[perkId].label

    draw: ->
      if @open
        super()
      return
