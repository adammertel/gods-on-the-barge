define 'WeatherPanel', ['Base', 'Panel', 'Text', 'Button'], (Base, Panel, Text, Button) ->
  class WeatherPanel extends Panel
    constructor: (@menu) ->
      @label = 'Weather'
      @weatherState = app.weather.state
      super @menu, @label
      return

    buildWindIndicator: ->
      @windIndicatorCenterX = centerX = @x + 150
      @windIndicatorCenterY = centerY = @y + 80

      radius = 50
      @windIndicator = new Path2D()
      @windIndicator.arc(centerX, centerY, radius, 0, 2 * Math.PI)

      @windIndicator.moveTo centerX, centerY - radius
      @windIndicator.lineTo centerX, centerY - radius + 10

      @windIndicator.moveTo centerX, centerY + radius
      @windIndicator.lineTo centerX, centerY + radius - 10

      @windIndicator.moveTo centerX - radius, centerY
      @windIndicator.lineTo centerX - radius + 10, centerY

      @windIndicator.moveTo centerX + radius, centerY
      @windIndicator.lineTo centerX + radius - 10, centerY

      radiusG = radius/10
      windDirectionCoords = [[0, -radiusG], [radiusG/2, radiusG], [0, radiusG/2], [-radiusG/2, radiusG]]
      console.log Base.buildPathString(windDirectionCoords, true)

      @windDirection = new Path2D Base.buildPathString(windDirectionCoords, true)

      return

    buildTemperatureIndicator: ->
      @temperatureMeter = new Path2D()
      x = @x + 350
      y = @y + 130
      @temperatureMeter.rect x, y , 20, -100

      return

    init: () ->
      @registerText 'windsLabel', {x: @x + 20, y: @y + 50}, @mst.bind(@, 'Winds'), @headerStyle
      @registerText 'temperatureLabel', {x: @x + 250, y: @y + 50}, @mst.bind(@, 'Temperature'), @headerStyle
      @buildWindIndicator()
      @buildTemperatureIndicator()
      super()

    drawWindGraphics: () ->
      app.ctx.stroke @windIndicator

      windSpeed = @weatherState.windSpeed
      windDirection = Base.degsToRad(@weatherState.windDirection)
      console.log @weatherState.windDirection

      if windSpeed and windDirection
        app.drawPath @windDirection, {x: @windIndicatorCenterX, y: @windIndicatorCenterY}, windSpeed, windDirection, 'black', false, false
      return

    drawingTemperatureGraphic: () ->
      app.ctx.stroke @temperatureMeter
      fullTemperature = -100
      thisTemperature = (fullTemperature / 10) * @weatherState.temperature
      app.ctx.fillStyle = 'red'
      app.ctx.fillRect @x + 355, @y + 130, 10, thisTemperature


    draw: () ->
      super()
      @drawWindGraphics()
      @drawingTemperatureGraphic()

      return
