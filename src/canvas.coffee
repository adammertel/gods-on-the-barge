define 'Canvas', ['Base'], (Base) ->
  class Canvas

    constructor: (@id, position, @z, @fps) ->
      @h = position.h
      @w = position.w
      @x = position.x
      @y = position.y

      @createCanvasElement()
      canvasDiv = document.getElementById 'canvas' + @id
      canvasDiv.style.left = @x + 'px'
      canvasDiv.style.top = @y + 'px'
      canvasDiv.style.zIndex = @z

      @ctx = canvasDiv.getContext '2d'
      @ctx.lineCap = 'round'
      @ctx.lineJoin = 'round'

      @drawFunctions = []
      @frameFunctions = []
      app.registerCanvas @

    # creating canvas element
    createCanvasElement: ->
      newCanvas = document.createElement 'canvas'
      newCanvas.width = @w
      newCanvas.height = @h
      newCanvas.id = 'canvas' + @id

      document.getElementById('canvases').appendChild newCanvas
      return

    registerFrameFunction: (frameFunction) ->
      @frameFunctions.push frameFunction
      return

    registerDrawFunction: (drawFunction) ->
      @drawFunctions.push drawFunction
      return

    render: ->
      @clear()
      for drawFunction in @drawFunctions
        drawFunction()
      return

    frame: ->
      for frameFunction in @frameFunctions
        frameFunction()
      return

    postRender: ->
      for drawFunction in @postDrawFunctions
        drawFunction()
      return

    clear: ->
      @ctx.clearRect 0, 0, @w, @h
      return
