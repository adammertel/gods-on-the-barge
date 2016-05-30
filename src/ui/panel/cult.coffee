define 'CultPanel', ['Base', 'Panel', 'Text', 'Colors', 'Button', 'ButtonStyle', 'TextStyle'], (Base, Panel, Text, Colors, Button, ButtonStyle, TextStyle) ->
  class CultPanel extends Panel
    constructor: (@menu) ->
      @label = 'Cult'
      super @menu, @label
      app.registerStartGameFunction @loadCultText.bind(@)
      return

    init: ->

      # statistics
      x = @x + 480
      dy = 12
      y = @y + 100
      l = 'cultStats'
      @registerText 'cult stats', {x: x-30, y: y-15}, @mst.bind(@, 'Statistics'), TextStyle.CENTEREDSMALLHEADER
      @dtdd {x: x, y: y, id: l + '1'}, {dt: @mst.bind(@, 'total believers:'), dd: app.game.getPlayerBelievers.bind(app.game)}
      @dtdd {x: x, y: y + 1*dy, id: l + '2'}, {dt: @mst.bind(@, 'dominance on islands:'), dd: app.game.getPlayerIslands.bind(app.game)}
      @dtdd {x: x, y: y + 2*dy, id: l + '3'}, {dt: @mst.bind(@, 'effectivity of conversion:'), dd: @playerStat.bind(@, 'religion', 'conversionEffectivity', 3)}
      @dtdd {x: x, y: y + 3*dy, id: l + '4'}, {dt: @mst.bind(@, 'resistance to conversion:'), dd: @playerStat.bind(@, 'religion', 'conversionResistance', 3)}

      # mana indicator annotation
      x = @x + 120
      y = @y + 100
      @registerText 'cult stats mana 1', {x: x, y: y-10}, @mst.bind(@, 'Mana'), TextStyle.BOLD
      @registerText 'cult stats mana 2', {x: x, y: y+5}, @getManaQuantity.bind(@), TextStyle.NORMAL
      @registerText 'cult stats mana 3', {x: x, y: y+20}, @getManaRegeneration.bind(@), TextStyle.NORMAL
      @buildManaIndicator()

      # special ability
      x = @x + 200
      y = @y + 20
      @registerText 'special-abb-label', {x: x, y: y}, @mst.bind(@, 'Special Ability'), TextStyle.HEADER
      @registerText 'special-abb-text', {x: x, y: y+20}, @specialAbilityText.bind(@), TextStyle.NORMAL
      @registerButton 'special-abb-button', {x: x, y: y+40, h: 30, w: 150}, @specialAbilityButtonLabel.bind(@), @runAbility.bind(@), @abilityButtonStyle.bind(app)

      super()

    specialAbilityButtonLabel: ->
      'run ability'

    runAbility: ->
      console.log 'run ability'
      false

    specialAbilityText: ->
      'blabla'

    abilityButtonStyle: ->
      playerCult = app.game.getPlayerCultLabel()
      if app.game.hasEnoughtMana(playerCult, 6)
        ButtonStyle.NORMALINACTIVE
      else
        ButtonStyle.NORMALDISABLED

    getManaQuantity: ->
      'quantity ' + @playerStat('mana', 'quantity', 3)

    getManaRegeneration: ->
      'regeneration rate ' + @playerStat('mana', 'baseRegeneration', 3)


    buildManaIndicator: ->
      @manaIndicator = new Path2D()
      @manaIndicatorX = @x + 100
      @manaIndicatorY = @y + 130
      @manaIndicator.rect @manaIndicatorX, @manaIndicatorY , 10, -100

    playerStat: (category, attribute, prec) ->
      value = app.game.getStat app.game.getPlayerCultLabel(), category, attribute
      Base.stringToPrec(value, prec)

    loadCultText: ->
      @registerText 'cultName', {x: @x + 30, y: @y + 120}, @mst.bind(@, app.game.getPlayerCultLabel()), TextStyle.BOLD
      return

    drawManaIndicator: ->
      @ctx.stroke @manaIndicator
      fullMana = -100
      thisTemperature = (fullMana / 10) *  @playerStat('mana', 'quantity', 5)
      @ctx.fillStyle = Colors.UIMANAINDICATOR
      @ctx.fillRect @manaIndicatorX, @manaIndicatorY, 10, thisTemperature

    draw: ->
      super()
      @drawManaIndicator()
      @ctx.drawImage app.game.getPlayerCultIcon(), @x + 20, @y + 40, 70, 70
      return
