define 'Collection', ['Base'], (Base) ->
  class Collection
    constructor: (@data) ->
      @geometries = []

    addGeometry: (geometry) ->
      geometry.id = @geometries.length
      @geometries.push geometry
      return

    draw: ->
      _.each @geometries, (geometry, g) ->
        if geometry
          geometry.draw()
        return
      return

    unregisterGeometry: (id) ->
      spliceIndex = false
      _.each @geometries, (geometry, g) =>
        if geometry.id == id
          spliceIndex = g

      if spliceIndex != false
        @geometries.splice spliceIndex, 1

      return
