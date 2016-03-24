define 'Base', [], () ->
  Base =
    doXhr: (link) ->
      xhr = new XMLHttpRequest
      xhr.open 'GET', link, false
      xhr.send ''
      xhr

    buildPathString: (coords, closed) ->
      path = "M"
      for c, i in coords
        if i == 0
          path += c[0] + " " + c[1]
        else
          path += " L " + c[0] + " " + c[1]
      if closed
        path += " Z"
      path


    #not finished
    shipPath: () ->
      shipCoords = [[0, 0], [5,5], [5,20], [-5,20], [-5,5], [0,0]]
      @buildPathString shipCoords, true

    loadIcon: (iconName, color) ->
      xhr = Base.doXhr './sprites/' + iconName + '.svg'
      img = new Image()
      svg = new XMLSerializer().serializeToString xhr.responseXML.documentElement
      if color
        svg = svg.replace(new RegExp('#666666', 'g'), color)
      img.src = 'data:image/svg+xml;base64,' + btoa unescape encodeURIComponent svg
      img

    round: (n) ->
      (0.5 + n) | 0

    distance: (c1, c2) ->
      dx = c1.x - c2.x
      dy = c1.y - c2.y
      Math.sqrt(dx * dx + dy * dy)

    moveTo: (from, to, distance) ->
      dx = to.x - from.x
      dy = to.y - from.y

      dist = @distance to, from
      dist_new = distance * app.state.pxkm

      d = dist_new / dist

      {x: d * dx + from.x, y: d * dy + from.y}


    pointInsidePolygon: (polygon, mouseCoordinates) ->
      #console.log mouseCoordinates

      x = mouseCoordinates.x
      y = mouseCoordinates.y

      inside = false
      #console.log polygon.viewCoords
      polygonCoords = polygon.viewCoords
      #console.log polygonCoords
      _.each polygonCoords, (p, i) =>
        j = i + 1
        if polygonCoords[j]
          q = polygonCoords[j]
          xi = p.x
          yi = p.y

          xj = q.x
          yj = q.y

          #console.log 'int', (yi > y) != (yj > y)
          #console.log 'i', xi, yi
          #console.log 'j', xj, yj

          intersect = (yi > y) != (yj > y) && (x < (xj - xi) * (y - yi) / (yj - yi) + xi)
          if intersect
            inside = !inside

      inside

    moveAtTheEndOfArray: (array, index) ->
      item = array[index]
      array.splice(index, 1)
      array.push item
      array

    openWebPage: (url) ->
      window.open(url, '_blank');
      return

    wrapText: (context, text, maxWidth) ->
      words = text.split(' ')
      line = ''
      wrapped = []
      n = 0
      while n < words.length
        testLine = line + words[n] + ' '
        metrics = context.measureText(testLine)
        testWidth = metrics.width
        if testWidth > maxWidth and n > 0
          wrapped.push line
          line = words[n] + ' '
        else
          line = testLine
        n++

      wrapped.push line
      wrapped
