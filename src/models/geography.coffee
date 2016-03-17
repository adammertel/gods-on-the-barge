#Geometry = require 'Geometry'

define 'Geography', ['Geometry'], (Geometry) ->
  class Geography extends Geometry
    constructor: () ->
      return

    getCoords: ->
      @viewCoords = @calculateCoords()
      return
