define 'Weather', ['Base', 'WeatherCalendar'], (Base, WeatherCalendar) ->
  class Weather
    state:
      storms: []
      windDirection: 0
      windSpeed: 0
      temperature: WeatherCalendar['temperature'][0][1] # 0-10
      config:
        temperatureAnomalyChance: 0.5

    constructor: () ->
      app.registerNewWeekAction @checkIfNewStorm.bind @
      app.registerNewDayAction @changeTemperature.bind @
      app.registerNewDayAction @changeWinds.bind @
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
      newStorm = Math.random() > 0.7
      if newStorm
        a = 4
        #console.log 'storm'
      return

    changeWinds: () ->
      #console.log 'changing winds'
      return
