define 'Geometry', ['Base'], (Base) ->
  class Geometry

    constructor: (@coords, @size, props) ->
      @props = _.assign( {
        color: '#666'
        minZoom: 1
      }, props
      )
      @rotation = 0

      @loadSprite()
      @loadImage()
      return

    mouseConflict: ->
      false

    changeColor: (newColor) ->
      @svg = @svg.replace(new RegExp(@color, 'g'), newColor)
      @color = newColor
      @loadImage()
      return

    rotate: () ->
      @svg = @svg.replace(new RegExp(/rotate\((\d*)/), 'rotate(' + @rotation)
      console.log @svg
      @lastRotation = @rotation
      return

    getCoords: ->
      hSize = (@size.w * app.state.zoom) / 2
      [
        {x: @coords.x - hSize,y: @coords.y - hSize},
        {x: @coords.x - hSize,y: @coords.y + hSize},
        {x: @coords.x + hSize,y: @coords.y + hSize},
        {x: @coords.x + hSize,y: @coords.y + hSize},
      ]

    loadImage: () ->
      @img = new Image()
      @img.src = 'data:image/svg+xml;base64,' + btoa @svg
      return

    getPosition: () ->
      {x: (@x - (app.state.position.x)) * app.state.zoom, y: (@y - (app.state.position.y)) * app.state.zoom}

    draw: () ->
      #if @rotation and @sprite and @lastRotation != @rotation
        #@rotate()
      if app.state.zoom >= @props.minZoom
        #position = app.coordinateToView({x: @coords.x, y: @coords.y})
        sizeW = @size.w * app.state.zoom
        sizeH = @size.h * app.state.zoom

        if @rotation and @sprite
          app.ctx.translate @shipCoord.x, @shipCoord.y
          app.ctx.rotate @rotation

        app.ctx.drawImage @img, -sizeW/2, -sizeH/2, sizeW, sizeH

        if @rotation and @sprite
          app.ctx.rotate -@rotation
          app.ctx.translate -@shipCoord.x, -@shipCoord.y
      return

    loadSprite: () ->
      if @sprite
        xhr = Base.doXhr './sprites/' + @sprite + '.svg'
        @svg = new XMLSerializer().serializeToString xhr.responseXML.documentElement
      return
