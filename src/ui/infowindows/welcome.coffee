define 'WelcomeWindow', ['InfoWindow', 'Button', 'Base', 'Colors', 'TextStyle', 'ButtonStyle', 'FontStyle'], (InfoWindow, Button, Base, Colors, TextStyle, ButtonStyle, FontStyle) ->
  class WelcomeWindow extends InfoWindow

    constructor: (@id, @w, @h) ->
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
      app.ctx.textAlign = 'left'
      text1 = 'WELCOME!'
      text2 = 'This is "Gods on the Barge" game inspired by the project of GEHIR (gehir.phil.muni.cz)'
      text3 = 'Your goal is to convert as many people in region as possible'
      text4 = 'Please choose a cult to play:'

      app.drawTextArea text1, @x + @m, @y + @m, @lineHeight, @lineWidth, FontStyle.HEADER
      app.drawTextArea text2, @x + @m, @y + @m + 20, @lineHeight, @lineWidth, FontStyle.BOLDNORMAL
      app.drawTextArea text3, @x + @m, @y + @m + 40, @lineHeight, @lineWidth, FontStyle.NORMAL
      app.drawTextArea text4, @x + @m, @y + @m + 60, @lineHeight, @lineWidth, FontStyle.NORMAL

      _.each app.game.state.cults, (cult, c) =>
        if @chosenCult == cult.label
          app.ctx.fillStyle = Colors.ACTIVEAREA
          app.ctx.fillRect @x + @m, @y + @m + 100*cult.no - 20, @w - 2*@m, 80
        app.drawTextArea cult.label, @x + @m + 80, @y + @m + 100*cult.no, @lineHeight, @lineWidth, 'bold 10pt Calibri'
        app.drawTextArea cult.text, @x + @m + 80, @y + @m + 20 + 100*cult.no, @lineHeight, @lineWidth, '8pt Calibri'


        logo = cult.logo
        app.ctx.drawImage logo, @x + @m, @y + @m + 100*cult.no - 20, 70, 70
        return
      return
