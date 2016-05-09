define 'PoliticsPanel', ['Panel', 'Text', 'Button', 'TextStyle', 'ButtonStyle', 'Colors'], (Panel, Text, Button, TextStyle, ButtonStyle, Colors) ->
  class PoliticsPanel extends Panel
    constructor: (@menu) ->
      @label = 'Politics'
      super @menu, @label
      return

    init: ->
      @registerText 'freePoints', {x: @x + 80, y: @y + 20, w: 100, h: 10}, @freePoints.bind(@), TextStyle.BOLD

      @endPoints = app.game.state.politics.endingPoints

      dy = 14
      y1 = @y + dy/2 + 14
      y2 = @y + dy/2 + 28

      for endPointId of @endPoints
        endNode = app.getCollection('nodes').getNode endPointId

        if endNode.island == 'Turkey'
          y = y1
          y1 += dy
          x = @x + 350
        else
          y = y2
          y2 += dy
          x = @x + 100

        @registerText 'pText' + endPointId, {x: x, y: y, w: 150, h: 8}, @mst.bind(@, endNode.port_name), TextStyle.RIGHTBOLDSMALL
        @registerButton 'pButton' + endPointId, {x: x + 10, y: y, w: 30, h: 11}, @mst.bind(@, 'vote'), @voteForPort.bind(@, endPointId), ButtonStyle.NORMALINACTIVE

      super()


    freePoints: ->
      'no points you can spent: ' + app.game.getPlayerPoliticsPoints() + '/' + app.game.getPlayerPoliticsMaxPoints()

    voteForPort: (pointId) ->
      app.game.playerVoteForEndingPoint pointId
      false

    drawPoliticsIndicators: ->
      @ctx.lineWidth = 1
      @ctx.strokeStyle = 'black'

      dy = 14
      y1 = @y + dy/2 + 14
      y2 = @y + dy/2 + 28

      for endPointId of @endPoints
        endNode = app.getCollection('nodes').getNode endPointId

        if endNode.island == 'Turkey'
          y = y1
          y1 += dy
          x = @x + 400
        else
          y = y2
          y2 += dy
          x = @x + 150

        politicsPower = app.game.state.politics.endingPoints[endPointId]

        if politicsPower > 7
          @ctx.fillStyle = Colors['POLITICSINDICATORSUPER']
        else if politicsPower > 4
          @ctx.fillStyle = Colors['POLITICSINDICATORGOOD']
        else
          @ctx.fillStyle = Colors['POLITICSINDICATORBAD']

        @ctx.fillRect x, y, 10 * politicsPower, 10
        @ctx.strokeRect x, y, 100, 10

    draw: ->
      @drawPoliticsIndicators()

      super()
      return
