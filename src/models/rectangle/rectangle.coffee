define 'Rectangle', ['Geometry'], (Geometry) ->
  class Rectangle extends Geometry
    constructor: (x, y, h, w, props, color)->
      super x, y, h, w, props
      @color = '#666'
      @changeColor color

    draw: () ->
      super

    sprite: 'rectangle'
