define 'IslandsPanel', ['Panel', 'Text', 'Button', 'Buildings', 'TextStyle', 'ButtonStyle', 'Base'], (Panel, Text, Button, Buildings, TextStyle, ButtonStyle, Base) ->
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
      @islands = _.orderBy app.getCollection('islands').geometries, 'data.name'

      dx = 100
      dy = 20
      y = @y + 5
      x = @x + 15
      for island, i in @islands
        name = island.data.name
        @registerButton true, 'island' + name, {x: x + Math.floor(i/7) * dx, y: y + (i % 7) * dy, w: dx - 10, h: dy - 5}, @mst.bind(@, name), @changeActiveIsland.bind(@, name), ButtonStyle.NORMALINACTIVE

      @registerText false, 'island_label', {x: x, y: y + 10}, @getActiveIslandLabel.bind(@), TextStyle.HEADER
      @registerButton false, 'returnToOverview', {x: x, y: y + 120, w: 60, h: 20}, @mst.bind(@, '< list'), @changeToOverviewMode.bind(@), ButtonStyle.NORMALINACTIVE

      # island Statistics
      @dtdd {x: x + 60, y: @y + 30, id: 'islandstats1'}, {dt: @mst.bind(@, 'population:'), dd: @activeIslandStat.bind(@, 'population')}
      @dtdd {x: x + 60, y: @y + 50, id: 'islandstats2'}, {dt: @mst.bind(@, 'area:'), dd: @activeIslandStat.bind(@, 'area')}
      @dtdd {x: x + 60, y: @y + 70, id: 'islandstats3'}, {dt: @mst.bind(@, 'grain:'), dd: @activeIslandGrainStat.bind(@)}
      @dtdd {x: x + 60, y: @y + 90, id: 'islandstats4'}, {dt: @mst.bind(@, 'starving:'), dd: @activeIslandStat.bind(@, 'starving')}
      @dtdd {x: x + 60, y: @y + 110, id: 'islandstats5'}, {dt: @mst.bind(@, 'rainfall:'), dd: @activeIslandStat.bind(@, 'rainfall')}

      @registerText false, 'construct', {x: @w - 30, y: y + 5}, @mst.bind(@, 'buildings:'), TextStyle.BOLD

      buildY = y
      for key, building of Buildings
        buildY += 20
        label = building.name
        @registerButton false, label, {x: @w - 30, y: buildY, w: 100, h: 18}, @mst.bind(@, label + ' - ' + building.price), @makeBuilding.bind(@, label), @isBuiltButtonStyle.bind(@, label)

      return

    dtdd: (props, dtdd) ->
      @registerText false, props.id + 'dt', {x: props.x , y: props.y}, dtdd.dt, TextStyle.DT
      @registerText false, props.id + 'dd', {x: props.x + 5, y: props.y}, dtdd.dd, TextStyle.DD
      return

    isBuiltButtonStyle: (building) ->
      if @islandCollection.hasIslandBuilding(@getActiveIslandLabel(), building)
        ButtonStyle.NORMALDISABLED
      else
        ButtonStyle.NORMALINACTIVE

    activeIslandGrainStat: ->
      Base.round(@activeIslandStat('grain')) + '/' + @activeIslandStat('maxGrain')

    activeIslandStat: (param) ->
      activeIsland = @getActiveIsland().state[param]

    makeBuilding: (building) ->
      @islandCollection.build app.game.getPlayerCultLabel(), @getActiveIslandLabel(), building
      return

    getActiveIslandLabel: ->
      @activeIsland

    getActiveIsland: ->
      @islandCollection.getIslandByName @getActiveIslandLabel()

    registerButton: (overview, id, position, text, action, style) ->
      if overview
        @overviewButtons.push new Button(id, position, text, action, style)
      else
        @focusButtons.push new Button(id, position, text, action, style)
      return

    registerText: (overview, id, position, text, font) ->
      if overview
        @overviewTexts.push new Text(id, position, text, font)
      else
        @focusTexts.push new Text(id, position, text, font)
      return

    changeActiveIsland: (island) ->
      @activeIsland = island
      @islandCollection.activateIslandByName island
      @buttons = _.clone @focusButtons
      @texts = _.clone @focusTexts
      return

    changeToOverviewMode: ->
      @islandCollection.deactivateIslands()
      @activeIsland = ''
      @buttons = _.clone @overviewButtons
      @texts = _.clone @overviewTexts
      return

    draw: ->
      super()
      return
