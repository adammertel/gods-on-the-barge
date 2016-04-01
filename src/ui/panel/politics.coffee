define 'PoliticsPanel', ['Panel', 'Text', 'Button', 'TextStyle', 'ButtonStyle', 'Colors'], (Panel, Text, Button, TextStyle, ButtonStyle, Colors) ->
  class PoliticsPanel extends Panel
    constructor: (@menu) ->
      @label = 'Politics'
      super @menu, @label
      return

    init: ->
      @registerText 'freePoints', {x: @x + 20, y: @y + 35, w: 100, h: 10}, @freePoints.bind(@), TextStyle.BOLD

      @endPoints = app.game.state.politics.endingPoints

      dy = @h/10
      y1 = @y + dy/2
      y2 = @y + dy/2 + 50

      for endPointId of @endPoints
        endNode = app.getCollection('nodes').getNode endPointId

        if endNode.island == 'Turkey'
          y = y1
          y1 += dy
          x = @x + 350
        else
          y = y2
          y2 += dy
          x = @x + 120

        @registerText 'pText' + endPointId, {x: x, y: y, w: 150, h: 10}, @mst.bind(@, endNode.port_name), TextStyle.RIGHTBOLD
        @registerButton 'pButton' + endPointId, {x: x + 10, y: y, w: 30, h: 13}, @mst.bind(@, 'vote'), @voteForPort.bind(@, endPointId), ButtonStyle.NORMALINACTIVE

      super()


    freePoints: ->
      'no points you can spent: ' + app.game.getPlayerPoliticsPoints() + '/' + app.game.getPlayerPoliticsMaxPoints()

    voteForPort: (pointId) ->
      app.game.playerVoteForEndingPoint pointId
      false

    drawPoliticsIndicators: ->
      app.ctx.lineWidth = 1
      app.ctx.strokeStyle = 'black'

      dy = @h/10
      y1 = @y + dy/2
      y2 = @y + dy/2 + 50

      for endPointId of @endPoints
        endNode = app.getCollection('nodes').getNode endPointId

        if endNode.island == 'Turkey'
          y = y1
          y1 += dy
          x = @x + 400
        else
          y = y2
          y2 += dy
          x = @x + 170

        politicsPower = app.game.state.politics.endingPoints[endPointId]

        if politicsPower > 7
          app.ctx.fillStyle = Colors['POLITICSINDICATORSUPER']
        else if politicsPower > 4
          app.ctx.fillStyle = Colors['POLITICSINDICATORGOOD']
        else
          app.ctx.fillStyle = Colors['POLITICSINDICATORBAD']

        app.ctx.fillRect x, y, 10 * politicsPower, 10
        app.ctx.strokeRect x, y, 100, 10

    draw: ->
      @drawPoliticsIndicators()

      super()
      return
