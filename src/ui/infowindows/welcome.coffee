define 'WelcomeWindow', ['InfoWindow', 'Button', 'Base', 'Colors', 'TextStyle', 'ButtonStyle', 'FontStyle'], (InfoWindow, Button, Base, Colors, TextStyle, ButtonStyle, FontStyle) ->
  class WelcomeWindow extends InfoWindow

    constructor: (@id, @w, @h) ->
      app.time.pause()
      super @id, @w, @h
      @chosenCult = 'Serapis'

      @init()
      return

    init: ->

      _.each app.game.state.cults, (cult, c) =>
        @registerClickableArea @x + @m, @y + @m + 100*cult.no, @w - 2*@m, 80, @chooseCultToPlay.bind(@, cult.label)

      buttonY = @y + @h - 60
      @registerButton 'play', {x: @x + @m, y: buttonY, w: 120, h: 40}, @makeStaticText.bind(@, 'PLAY!'), @play.bind(@), ButtonStyle.NORMALINACTIVE
      @registerButton 'info', {x: @x + @m + 200, y: buttonY, w: 120, h: 40}, @makeStaticText.bind(@, 'GAME INFO'), @getGameInfo.bind(@), ButtonStyle.NORMALINACTIVE
      @registerButton 'gehir', {x: @x + @m + 400, y: buttonY, w: 120, h: 40}, @makeStaticText.bind(@, 'GEHIR WEBPAGE'), @visitGehir.bind(@), ButtonStyle.NORMALINACTIVE

    play: ->
      @open = false
      app.startGame @chosenCult
      return

    visitGehir: ->
      Base.openWebPage 'http://gehir.phil.muni.cz'
      return

    getGameInfo: ->
      Base.openWebPage 'https://github.com/adammertel/gods_on_the_barge'
      return

    chooseCultToPlay: (cult) ->
      @chosenCult = cult
      return

    draw: ->
      super()
      @ctx.textAlign = 'left'
      text1 = 'WELCOME!'
      text2 = 'This is "Gods on the Barge" game (current state: v 0.1) inspired by the project of GEHIR (gehir.phil.muni.cz)'
      text3 = 'Your goal is to convert as many people in region as possible'
      text4 = 'Please choose a cult to play:'

      lineWidth = @lineWidth
      app.drawTextArea @ctx, text1, @x + @m, @y + @m, @lineHeight, lineWidth, FontStyle.HEADER
      app.drawTextArea @ctx, text2, @x + @m, @y + @m + 20, @lineHeight, lineWidth, FontStyle.BOLDNORMAL
      app.drawTextArea @ctx, text3, @x + @m, @y + @m + 60, @lineHeight, lineWidth, FontStyle.NORMAL
      app.drawTextArea @ctx, text4, @x + @m, @y + @m + 80, @lineHeight, lineWidth, FontStyle.NORMAL

      _.each app.game.state.cults, (cult, c) =>
        if @chosenCult == cult.label
          @ctx.fillStyle = Colors.ACTIVEAREA
          @ctx.fillRect @x + @m - 10, @y + @m + 100*cult.no - 20, @w - 2*@m + 30, 80
        app.drawTextArea @ctx, cult.label, @x + @m + 80, @y + @m + 100*cult.no, @lineHeight, @lineWidth - 70, 'bold 10pt Calibri'
        app.drawTextArea @ctx, cult.text, @x + @m + 80, @y + @m + 20 + 100*cult.no, @lineHeight, @lineWidth - 70, '8pt Calibri'


        logo = cult.logo
        @ctx.drawImage logo, @x + @m, @y + @m + 100*cult.no - 20, 70, 70
        return
      return
