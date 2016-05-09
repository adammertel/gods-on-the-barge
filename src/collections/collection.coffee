define 'Collection', ['Base'], (Base) ->
  class Collection
    constructor: (@data) ->
      @geometries = []

    setCanvas: (@canvas) ->
      @ctx = @canvas.ctx
      @canvas.registerDrawFunction @draw.bind(@)
      @canvas.registerPostDrawFunction @drawLabels.bind(@)
      @setStyle()
      return

    addGeometry: (geometry) ->
      geometry.id = @geometries.length
      @geometries.push geometry
      return

    setStyle: ->
      return

    draw: ->
      for geometry in @geometries
        if geometry
          geometry.draw()
      return

    drawLabels: ->
      return

    unregisterGeometry: (id) ->
      spliceIndex = false
      for geometry, g in @geometries
        if geometry.id == id
          spliceIndex = g

      if spliceIndex != false
        @geometries.splice spliceIndex, 1

      return
