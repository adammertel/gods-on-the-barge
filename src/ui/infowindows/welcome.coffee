define 'WelcomeWindow', ['InfoWindow', 'Base'], (InfoWindow, Base) ->
  class WelcomeWindow extends InfoWindow


    draw: () ->
      super()
      text1 = 'WELCOME!'
      text2 = 'This is "Gods on the Barge game" inspired by the project of GEHIR (gehir.phil.muni.cz)'
      text3 = 'Please choose a cult to play:'
      app.drawTextArea text1, @x + @m, @y + @m, @lineHeight, @lineWidth, 'bold 12pt Calibri'
      app.drawTextArea text2, @x + @m, @y + @m + 30, @lineHeight, @lineWidth, '8pt Calibri'
      app.drawTextArea text3, @x + @m, @y + @m + 50, @lineHeight, @lineWidth, '8pt Calibri'

      _.each app.cults.state.cults, (cult, c) =>
        app.drawTextArea cult.label, @x + @m + 80, @y + @m + 80*cult.no, @lineHeight, @lineWidth, 'bold 10pt Calibri'
        app.drawTextArea cult.text, @x + @m + 80, @y + @m + 20 + 80*cult.no, @lineHeight, @lineWidth, '8pt Calibri'

        logo = cult.logo
        try
          #console.log logo
          app.ctx.drawImage logo, @x + @m, @y + @m + 80*cult.no - 20, 50, 50
        catch error
          #console.log 'logo not loaded yet', error
        return
      return
