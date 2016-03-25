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
      'week ' + app.time.state.week + '/13'

    getSeasonYearLabel: () ->
      app.time.state.season + ', ' + app.time.state.year + ' BC'

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

    indexOfSeason: ->
      foundIndex = false
      for index, seasonName of Season
        if seasonName == @state.season
          foundIndex = index
      foundIndex

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
