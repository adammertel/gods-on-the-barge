define 'Base', [], () ->
  Base =
    doXhr: (link) ->
      xhr = new XMLHttpRequest
      xhr.open 'GET', link, false
      xhr.send ''
      xhr

    validateAngle: (unvalidatedAngle) ->
      angle = unvalidatedAngle % 360
      if angle < 0
        angle = 360 - Math.abs angle
      angle

    flipAngle: (angle) ->
      if angle < 180
        angle + 180
      else
        angle - 180

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

    concatPathStrings: (paths) ->
      paths.join ' '

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

    degsToRad: (deg) ->
      deg * (Math.PI/180)

    radToDegs: (rad) ->
      rad / (Math.PI/180)

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

    moveInDirection: (fromCoord, direction, distance) ->
      rads = @degsToRad @flipAngle direction

      dx = Math.sin(rads) * distance
      dy = Math.cos(rads) * distance
      {x: fromCoord.x - dx, y: fromCoord.y + dy}

    pointInsidePolygon: (polygon, mouseCoordinates) ->

      x = mouseCoordinates.x
      y = mouseCoordinates.y

      inside = false
      polygonCoords = polygon.viewCoords
      _.each polygonCoords, (p, i) =>
        j = i + 1
        if polygonCoords[j]
          q = polygonCoords[j]
          xi = p.x
          yi = p.y

          xj = q.x
          yj = q.y

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
