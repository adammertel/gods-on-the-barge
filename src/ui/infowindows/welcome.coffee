define 'WelcomeWindow', ['InfoWindow', 'Button','Base'], (InfoWindow, Button, Base) ->
  class WelcomeWindow extends InfoWindow

    constructor: (@id, @w, @h) ->
      super @id, @w, @h
      @chosenCult = 'Serapis'

      @init()
      return

    init: () ->
      bs = _.clone @buttonStyle
      bs.inactive.font = 'bold 12pt Calibri'
      console.log bs

      _.each app.game.state.cults, (cult, c) =>
        @registerClickableArea @x + @m, @y + @m + 100*cult.no, @w - 2*@m, 80, @chooseCultToPlay.bind(@, cult.label)

      buttonY = @y + @h - 60
      @registerButton 'play', {x: @x + @m, y: buttonY, w: 120, h: 40}, @makeStaticText.bind(@, 'play!'), @play.bind(@), bs, false
      @registerButton 'info', {x: @x + @m + 200, y: buttonY, w: 120, h: 40}, @makeStaticText.bind(@, 'game info'), @getGameInfo.bind(@), bs, false
      @registerButton 'gehir', {x: @x + @m + 400, y: buttonY, w: 120, h: 40}, @makeStaticText.bind(@, 'gehir webpage'), @visitGehir.bind(@), bs, false

    play: () ->
      @open = false
      app.play @chosenCult

    visitGehir: () ->
      Base.openWebPage 'http://gehir.phil.muni.cz'
      return

    getGameInfo: () ->
      Base.openWebPage 'https://github.com/adammertel/gods_on_the_barge'
      return

    chooseCultToPlay: (cult) ->
      @chosenCult = cult
      return

    draw: () ->
      super()
      app.ctx.textAlign = 'left'
      text1 = 'WELCOME!'
      text2 = 'This is "Gods on the Barge" game inspired by the project of GEHIR (gehir.phil.muni.cz)'
      text3 = 'Your goal is to convert as many people in region as possible'
      text4 = 'Please choose a cult to play:'
      app.drawTextArea text1, @x + @m, @y + @m, @lineHeight, @lineWidth, 'bold 12pt Calibri'
      app.drawTextArea text2, @x + @m, @y + @m + 20, @lineHeight, @lineWidth, '8pt Calibri'
      app.drawTextArea text3, @x + @m, @y + @m + 40, @lineHeight, @lineWidth, '8pt Calibri'
      app.drawTextArea text4, @x + @m, @y + @m + 60, @lineHeight, @lineWidth, '8pt Calibri'

      _.each app.game.state.cults, (cult, c) =>
        app.drawTextArea cult.label, @x + @m + 80, @y + @m + 100*cult.no, @lineHeight, @lineWidth, 'bold 10pt Calibri'
        app.drawTextArea cult.text, @x + @m + 80, @y + @m + 20 + 100*cult.no, @lineHeight, @lineWidth, '8pt Calibri'

        if @chosenCult == cult.label
          app.ctx.strokeRect @x + @m, @y + @m + 100*cult.no - 20, @w - 2*@m, 80

        logo = cult.logo
        try
          app.ctx.drawImage logo, @x + @m, @y + @m + 100*cult.no - 20, 70, 70
        catch error
        return
      return
