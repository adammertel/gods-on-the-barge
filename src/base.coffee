define 'Base', [], () ->
  Base =
    doXhr: (link) ->
      xhr = new XMLHttpRequest
      xhr.open 'GET', link, false
      xhr.send ''
      xhr

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
