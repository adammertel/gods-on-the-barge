define 'Collection', ['Base'], (Base) ->
  class Collection
    constructor: (@data) ->
      @geometries = []

    addGeometry: (geometry) ->
      geometry.id = @geometries.length
      @geometries.push geometry
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
