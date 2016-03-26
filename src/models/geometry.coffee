define 'Geometry', ['Base'], (Base) ->
  class Geometry

    constructor: (@coords, @size, props) ->
      @props = _.assign( {
        defaultColor: '#666666'
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
      @svg = @svg.replace(new RegExp(@props.defaultColor, 'g'), newColor)
      @color = newColor
      @loadImage()
      return

    getCoords: ->
      hSize = (@size.w * app.state.zoom) / 2
      [
        {x: @coords.x - hSize,y: @coords.y - hSize},
        {x: @coords.x - hSize,y: @coords.y + hSize},
        {x: @coords.x + hSize,y: @coords.y + hSize},
        {x: @coords.x + hSize,y: @coords.y + hSize},
      ]

    loadImage: ->
      @img = new Image()
      @img.src = 'data:image/svg+xml;base64,' + btoa @svg
      return

    getPosition: ->
      {x: (@x - (app.state.position.x)) * app.state.zoom, y: (@y - (app.state.position.y)) * app.state.zoom}

    draw: ->
      if app.state.zoom >= @props.minZoom
        sizeW = Base.round @size.w * app.state.zoom
        sizeH = Base.round @size.h * app.state.zoom

        if @rotation and @sprite
          app.ctx.translate @shipCoord.x, @shipCoord.y
          app.ctx.rotate @rotation
          app.ctx.scale 2, 2

        app.ctx.drawImage @img, -sizeW/2, -sizeH/2, sizeW, sizeH

        if @rotation and @sprite
          app.ctx.scale 0.5, 0.5
          app.ctx.rotate -@rotation
          app.ctx.translate -@shipCoord.x, -@shipCoord.y
      return

    loadSprite: ->
      if @sprite
        xhr = Base.doXhr './sprites/' + @sprite + '.svg'
        @svg = new XMLSerializer().serializeToString xhr.responseXML.documentElement
      return
