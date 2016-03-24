define 'Weather', ['Base', 'WeatherCalendar', 'Storm'], (Base, WeatherCalendar, Storm) ->
  class Weather
    storms: []
    state:
      lastStormId: 0
      windDirection: 0
      windSpeed: 0
      temperature: WeatherCalendar['temperature'][0][1] # 0-10
      config:
        temperatureAnomalyChance: 0.5

    constructor: () ->
      app.registerNewWeekAction @checkIfNewStorm.bind @
      app.registerNewDayAction @changeTemperature.bind @
      app.registerNewDayAction @changeWinds.bind @
      app.registerNewDayAction @reduceStormsPower.bind @
      return

    reduceStormsPower: () ->
      for storm in @storms
        if storm
          storm.reducePower()
      return

    findStormWithId: (id) ->
      foundStorm = false
      for storm in @storms
        if id == storm
          foundStorm = storm
      foundStorm

    indexOfStormWithId: (id) ->
      foundIndex = false
      for storm, index in @storms
        if id == storm.id
          foundIndex = index
      foundIndex

    disbandStorm: (id) ->
      index = @indexOfStormWithId(id)
      if index != false
        @storms.splice index, 1
      return

    getStormChanceForThisWeek: () ->
      seasonIndex = app.time.indexOfSeason()
      WeatherCalendar['stormChance'][seasonIndex][app.time.state.week]

    getTemperatureForThisWeek: () ->
      seasonIndex = app.time.indexOfSeason()
      WeatherCalendar['temperature'][seasonIndex][app.time.state.week]

    changeTemperature: () ->
      anomaly = _.random(0, 1) < @state.config.temperatureAnomalyChance
      predicatedTemperature = @getTemperatureForThisWeek()

      if anomaly
        anomalyPower = Math.ceil _.random(0, 1.5)
        positiveAnomaly = _.random(0, 1) < 0.5
        if positiveAnomaly
          @state.temperature = predicatedTemperature + anomalyPower
        else
          @state.temperature = predicatedTemperature - anomalyPower
      else
        @state.temperature = predicatedTemperature

      return

    checkIfNewStorm: () ->
      newStorm = Math.random() > @getStormChanceForThisWeek()
      if newStorm
        @storms.push new Storm(@state.lastStormId)
        @lastStormId += 1
      return

    changeWinds: () ->
      #console.log 'changing winds'
      return
