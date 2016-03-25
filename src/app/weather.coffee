define 'Weather', ['Base', 'WeatherCalendar', 'Storm'], (Base, WeatherCalendar, Storm) ->
  class Weather
    storms: []
    state:
      lastStormId: 0
      windDirection: 180
      windSpeed: WeatherCalendar['windSpeed'][0][1]
      temperature: WeatherCalendar['temperature'][0][1] # 0-10
      config:
        temperatureAnomalyChance: 0.5
        windSpeedAnomalyChance: 0.5
        maxWindDirectionChange: 30
        stormRadiusCoefficient: 100
        stormSpeedCoefficient: 2

    constructor: () ->
      app.registerNewWeekAction @checkIfNewStorm.bind @
      app.registerNewDayAction @reduceStormsPower.bind @

      app.registerNewDayAction @changeTemperature.bind @
      app.registerNewDayAction @changeWinds.bind @
      app.registerNewDayAction @changeWindSpeed.bind @

      return

    reduceStormsPower: () ->
      app.getCollection('storms').reducePower()
      return

    getStormChanceForThisWeek: () ->
      seasonIndex = app.time.indexOfSeason()
      WeatherCalendar['stormChance'][seasonIndex][app.time.state.week]

    getTemperatureForThisWeek: () ->
      seasonIndex = app.time.indexOfSeason()
      WeatherCalendar['temperature'][seasonIndex][app.time.state.week]

    getWindSpeedForThisWeek: () ->
      seasonIndex = app.time.indexOfSeason()
      WeatherCalendar['windSpeed'][seasonIndex][app.time.state.week]

    changeWindSpeed: () ->
      anomaly = _.random(0, 1) < @state.config.windSpeedAnomalyChance
      predicatedWindSpeed = @getWindSpeedForThisWeek()

      if anomaly
        anomalyPower = Math.ceil _.random(0, 1.5)
        positiveAnomaly = _.random(0, 1) < 0.5
        if positiveAnomaly
          @state.windSpeed = predicatedWindSpeed + anomalyPower
        else
          @state.windSpeed = predicatedWindSpeed - anomalyPower
      else
        @state.windSpeed = predicatedWindSpeed

      return

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
      newStorm = Math.random() > 0#@getStormChanceForThisWeek()
      if newStorm
        app.getCollection('storms').addGeometry new Storm(@state.lastStormId)
        @state.lastStormId += 1
      return

    changeWinds: () ->
      maxChange = @state.config.maxWindDirectionChange
      directionChange = _.random -maxChange, maxChange, false
      @state.windDirection = _.clamp(Base.validateAngle(@state.windDirection + directionChange), 90, 270)
      @state.windDirection
      return
