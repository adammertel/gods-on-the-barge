define 'IslandsPanel', ['Panel', 'Text', 'Button', 'Buildings'], (Panel, Text, Button, Buildings) ->
  class IslandsPanel extends Panel
    constructor: (@menu) ->
      @label = 'Islands'
      @overviewButtons = []
      @focusButtons = []
      @overviewTexts = []
      @focusTexts = []
      @activeIsland = ''
      @islandCollection = app.getCollection 'islands'

      super @menu, @label
      @changeToOverviewMode()

    init: ->
      bs = {
        inactive: {stroke: 'black', fill: '#ccc', text: 'black', lw: 2, font: 'bold 9pt Calibri'}
      }
      @islands = _.orderBy app.getCollection('islands').geometries, 'data.name'

      dx = 100
      dy = 20
      y = @y + 5
      x = @x + 15
      for island, i in @islands
        name = island.data.name
        @registerButton true, 'island' + name, {x: x + Math.floor(i/7) * dx, y: y + (i % 7) * dy, w: dx - 10, h: dy - 5}, @mst.bind(@, name), @changeActiveIsland.bind(@, name), bs, false

      # focus part
      bs = {
        inactive: {stroke: 'black', fill: 'white', text: 'black', lw: 2, font: 'bold 10pt Calibri'}
        active: {stroke: 'black', fill: '#bbb', text: 'black', lw: 2, font: 'bold 10pt Calibri'}
      }

      @registerText false, 'island_label', {x: x, y: y + 10}, @getActiveIslandLabel.bind(@), @headerStyle
      @registerButton false, 'returnToOverview', {x: x, y: y + 120, w: 60, h: 20}, @mst.bind(@, '< list'), @changeToOverviewMode.bind(@), bs, false

      # island Statistics
      @dtdd {x: x + 60, y: @y + 50, id: 'islandstats1'}, {dt: @mst.bind(@, 'population:'), dd: @activeIslandStat.bind(@, 'population')}
      @dtdd {x: x + 60, y: @y + 70, id: 'islandstats2'}, {dt: @mst.bind(@, 'area:'), dd: @activeIslandStat.bind(@, 'area')}
      @dtdd {x: x + 60, y: @y + 90, id: 'islandstats2'}, {dt: @mst.bind(@, 'grain:'), dd: @activeIslandStat.bind(@, 'grain')}

      @registerText false, 'construct', {x: @w - 30, y: y + 5}, @mst.bind(@, 'buildings:'), @boldTextStyle

      buildY = y + 20
      for key, building of Buildings
        console.log building
        label = building.name
        @registerButton false, label, {x: @w - 30, y: buildY, w: 100, h: 20}, @mst.bind(@, label + ' - ' + building.price), @makeBuilding.bind(@, label), bs, false
        buildY += 30

      return


    dtdd: (props, dtdd) ->
      @registerText false, props.id + 'dt', {x: props.x , y: props.y}, dtdd.dt, @dtTextStyle
      @registerText false, props.id + 'dd', {x: props.x + 5, y: props.y}, dtdd.dd, @ddTextStyle
      return

    activeIslandStat: (param) ->
      activeIsland = @getActiveIsland().state[param]

    makeBuilding: (building) ->
      @islandCollection.build app.game.getPlayerCultLabel(), @getActiveIslandLabel(), building
      @activateBuildingsButtons()
      return

    activateBuildingsButtons: ->
      for key, building of Buildings
        if @islandCollection.hasIslandBuilding @getActiveIslandLabel(), building.name
          @getButton(building.name).activate()
        else
          @getButton(building.name).deactivate()

    getActiveIslandLabel: ->
      @activeIsland

    getActiveIsland: ->
      @islandCollection.getIslandByName @getActiveIslandLabel()

    registerButton: (overview, id, position, text, action, style, active) ->
      if overview
        @overviewButtons.push new Button(id, position, text, action, style, active)
      else
        @focusButtons.push new Button(id, position, text, action, style, active)
      return

    registerText: (overview, id, position, text, font) ->
      if overview
        @overviewTexts.push new Text(id, position, text, font)
      else
        @focusTexts.push new Text(id, position, text, font)
      return

    changeActiveIsland: (island) ->
      @activeIsland = island
      console.log @activeIsland
      @buttons = _.clone @focusButtons
      @texts = _.clone @focusTexts
      @activateBuildingsButtons()
      return

    changeToOverviewMode: ->
      @activeIsland = ''
      @buttons = _.clone @overviewButtons
      @texts = _.clone @overviewTexts
      return

    draw: ->
      super()
      return
