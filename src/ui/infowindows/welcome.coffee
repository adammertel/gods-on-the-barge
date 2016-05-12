define 'WelcomeWindow', ['InfoWindow', 'Button', 'Base', 'Colors', 'TextStyle', 'ButtonStyle', 'FontStyle'], (InfoWindow, Button, Base, Colors, TextStyle, ButtonStyle, FontStyle) ->
  class WelcomeWindow extends InfoWindow

    constructor: (@id, @w, @h) ->
      app.time.pause()
      super @id, @w, @h
      @chosenCult = 'Serapis'
      @cultAreaHeight = 70
      @cultAreaY = @y + @m + 150

      @init()
      return

    init: ->
      _.each app.game.state.cults, (cult, c) =>
        w = @cultAreaHeight*cult.no + @cultAreaY
        @registerClickableArea @x + @m, w - 20, @w - 2*@m, @cultAreaHeight, @chooseCultToPlay.bind(@, cult.label)

      buttonY = @y + @h - 60

      @registerButton 'play', {x: @x + @m, y: buttonY, w: 120, h: 40}, @makeStaticText.bind(@, 'PLAY!'), @play.bind(@), ButtonStyle.NORMALINACTIVE
      @registerButton 'info', {x: @x + @m + 200, y: buttonY, w: 120, h: 40}, @makeStaticText.bind(@, 'GAME INFO'), @getGameInfo.bind(@), ButtonStyle.NORMALINACTIVE
      @registerButton 'gehir', {x: @x + @m + 400, y: buttonY, w: 120, h: 40}, @makeStaticText.bind(@, 'GEHIR WEBPAGE'), @visitGehir.bind(@), ButtonStyle.NORMALINACTIVE

    play: ->
      @close()
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
      if @open
        super()
        @ctx.textAlign = 'left'
        text1 = 'WELCOME TO GODS ON THE BARGE GAME!'
        text2 = 'This is "Gods on the Barge" game (current state: v 0.2) inspired by the project of GEHIR based on Masaryk University, Brno. At this version of the game, we are not able to provide full implementation of all features. Game itself is also not fully balanced and several bugs may appear (game is tested only in chrome).'
        text3 = 'Your goal is to convert as many islands in region as possible. The crucial part of spreading religion are ships, that are sent to Greece/Turkey from Alexandria and will occasionally stop on various islands to sell food.'
        text4 = 'Please choose a cult to play:'

        lineWidth = @lineWidth
        app.drawTextArea @ctx, text1, @x + @m, @y + @m, @lineHeight, @lineWidth, FontStyle.HEADER
        app.drawTextArea @ctx, text2, @x + @m, @y + @m + 30, @lineHeight - 3, @lineWidth, FontStyle.NORMAL
        app.drawTextArea @ctx, text3, @x + @m, @y + @m + 115, @lineHeight - 3, @lineWidth, FontStyle.NORMAL
        app.drawTextArea @ctx, text4, @x + @m, @y + @m + 180, @lineHeight, @lineWidth, FontStyle.NORMAL

        lh = @lineHeight - 5
        lw = @lineWidth - 70
        _.each app.game.state.cults, (cult, c) =>
          w = @cultAreaHeight*cult.no + @cultAreaY

          if @chosenCult == cult.label
            @ctx.fillStyle = Colors.ACTIVEAREA
            @ctx.fillRect @x + @m - 10, w - 20, @w - 2*@m + 30, @cultAreaHeight

          app.drawTextArea @ctx, cult.label, @x + @m + 80, w, lh, lw, 'bold 10pt Calibri'
          app.drawTextArea @ctx, cult.text, @x + @m + 80, w + 20, lh, lw, '8pt Calibri'

          logo = cult.logo
          @ctx.drawImage logo, @x + @m, w - 10, @cultAreaHeight - 20, @cultAreaHeight - 20
          return
      return
