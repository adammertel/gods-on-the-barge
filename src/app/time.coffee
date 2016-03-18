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
      @labelx = app.state.view.w - 100
      @labely = 20
      return

    changeGameSpeed: (newSpeed) ->
      @state.timeSpeed = newSpeed
      return

    getDatumLabel: () ->
      'week: ' + @state.week + '; year: ' + @state.year + ' BC'

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

    draw: () ->
      app.ctx.fillStyle = 'black'
      app.ctx.fillText @getDatumLabel(), @labelx, @labely
      return
