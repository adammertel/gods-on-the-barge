define 'Time', ['Base', 'Season'], (Base, Season) ->
  class Time
    state:
      timeSpeed: 1
      year: 400
      week: 1
      season: Season[0]
      day: 1
      yearPart: 0
      frameInterval: 0.00005

    constructor: () ->
      @labelx = app.state.view.w - 40
      @labely = 20
      return

    changeGameSpeed: (newSpeed) ->
      @state.timeSpeed = newSpeed
      return

    getWeekLabel: () ->
      'week ' + @state.week + '/13'

    getSeasonYearLabel: () ->
      @state.season + ', ' + @state.year + ' BC'

    nextTick: () ->
      lastFrame = _.clone @state.yearPart
      yearPart = @state.yearPart += @state.timeSpeed * @state.frameInterval

      if yearPart > 1
        @newYear()
      else
        dayOfYearLastFrame = Math.floor(lastFrame*364)
        dayOfYear = Math.floor(yearPart*364)

        if dayOfYearLastFrame != dayOfYear
          newSeason = Season[Math.floor(dayOfYear/91)]
          newWeek = Math.floor(dayOfYear/7)
          if newSeason != @state.season
            @newSeason(newSeason)
          else if dayOfYear % 7 == 0 #newWeek != @state.week
            @newWeek()
          else
            @newDay()
      return

    newDay: ->
      console.log 'newDay'
      @state.day += 1
      app.newDay()
      return

    newWeek: ->
      console.log 'newWeek'
      @state.day = 0
      @state.week += 1
      app.newWeek()
      return

    newSeason: (newSeason)->
      console.log 'newSeason'
      @state.day = 0
      @state.week = 0
      @state.season = newSeason
      app.newSeason()
      return

    newYear: ->
      console.log 'newYear'
      @state.day = 0
      @state.week = 0
      @state.season = Season[0]
      app.newYear()
      return

    drawGlassHours: ->
      h = 35
      w = 20
      d = 5
      x1 = @labelx+10
      x2 = x1 + w
      y1 = @labely-10
      y2 = y1 + h

      xc1 = x1 + (w/2 - d/2)
      xc2 = x1 + (w/2 + d/2)
      yc = y1 + h/2

      app.ctx.fillStyle = 'orange'
      dh = h * @state.day/7
      app.ctx.fillRect x1, y1 + dh, w, h - dh

      app.ctx.fillStyle = 'white'
      app.ctx.beginPath()
      app.ctx.moveTo x1, y1
      app.ctx.lineTo xc1, yc
      app.ctx.lineTo x1, y2
      app.ctx.closePath()
      app.ctx.fill()
      app.ctx.beginPath()
      app.ctx.moveTo x2, y1
      app.ctx.lineTo xc2, yc
      app.ctx.lineTo x2, y2
      app.ctx.closePath()
      app.ctx.fill()

      app.ctx.fillStyle = 'black'
      app.ctx.beginPath()
      app.ctx.lineWidth = 2
      app.ctx.moveTo x1, y1
      app.ctx.lineTo xc1, yc
      app.ctx.lineTo x1, y2
      app.ctx.lineTo x2, y2
      app.ctx.lineTo xc2, yc
      app.ctx.lineTo x2, y1
      app.ctx.closePath()
      app.ctx.stroke()

      return

    draw: () ->
      app.ctx.fillStyle = 'white'
      app.ctx.fillRect @labelx - 80, 0, 200, 50
      app.ctx.fillStyle = 'black'
      app.ctx.textAlign = 'right';
      app.ctx.fillText @getWeekLabel(), @labelx, @labely
      app.ctx.fillText @getSeasonYearLabel(), @labelx, @labely + 20
      @drawGlassHours()
      return
