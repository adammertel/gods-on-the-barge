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
      @builGlass()
      return

    pause: () ->
      @state.timeSpeedBeforePause = @state.timeSpeed
      @state.timeSpeed = 0
      return

    resume: () ->
      @state.timeSpeed = @state.timeSpeedBeforePause
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
      @state.yearPart += @state.timeSpeed * @state.frameInterval
      yearPart = @state.yearPart

      if yearPart > 1
        @state.yearPart = 0
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
      @state.day = 1
      @state.week += 1
      app.newWeek()
      return

    newSeason: (newSeason)->
      console.log 'newSeason'
      @state.day = 1
      @state.week = 1
      @state.season = newSeason
      app.newSeason()
      return

    newYear: ->
      console.log 'newYear'
      @state.day = 1
      @state.week = 1
      @state.season = Season[0]
      @state.year -= 1
      app.newYear()
      return

    drawGlassHours: ->
      h = 36
      w = 20
      d = 6
      x1 = @labelx+10
      y1 = @labely-10

      xc1 = x1 + (w/2 - d/2)
      xc2 = x1 + (w/2 + d/2)
      yc = y1 + h/2

      app.ctx.fillStyle = 'orange'
      dh = h * (@state.day-1)/7
      app.ctx.fillRect x1, y1 + dh, w, h - dh

      app.ctx.lineWidth = 2
      app.ctx.fillStyle = 'white'
      app.ctx.fill @pathTriangle1
      app.ctx.fill @pathTriangle2
      app.ctx.stroke @pathGlass
      return

    builGlass: () ->
      h = 36
      w = 20
      d = 6
      x1 = @labelx+10
      x2 = x1 + w
      y1 = @labely-10
      y2 = y1 + h

      xc1 = x1 + (w/2 - d/2)
      xc2 = x1 + (w/2 + d/2)
      yc = y1 + h/2

      glassCoords = [[x1, y1], [xc1, yc], [x1, y2], [x2, y2], [xc2, yc], [x2, y1]]
      glassWhiteTriangle1Coords = [[x1, y1], [xc1, yc], [x1, y2]]
      glassWhiteTriangle2Coords = [[x2, y1], [xc2, yc], [x2, y2]]

      @pathGlass = new Path2D(Base.buildPathString glassCoords, true)
      @pathTriangle1 = new Path2D(Base.buildPathString glassWhiteTriangle1Coords, true)
      @pathTriangle2 = new Path2D(Base.buildPathString glassWhiteTriangle2Coords, true)

      return

    draw: () ->
      app.ctx.fillStyle = 'white'
      app.ctx.fillRect @labelx - 80, 0, 200, 50
      app.ctx.fillStyle = 'black'
      app.ctx.textAlign = 'right'
      app.ctx.fillText @getWeekLabel(), @labelx, @labely
      app.ctx.fillText @getSeasonYearLabel(), @labelx, @labely + 20
      @drawGlassHours()
      app.ctx.textAlign = 'left'
      return
