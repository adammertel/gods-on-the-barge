require ['App'], (app) ->
  window.addEventListener 'keydown', (e) ->
    if e.keyCode == 37
      app.state.controls.left = true
    if e.keyCode == 38
      app.state.controls.up = true
    if e.keyCode == 39
      app.state.controls.right = true
    if e.keyCode == 40
      app.state.controls.down = true

    if e.keyCode == 33
      app.zoomIn()
    if e.keyCode == 34
      app.zoomOut()
  , false

  window.addEventListener 'keyup', (e) ->
    if e.keyCode == 37
      app.state.controls.left = false
    if e.keyCode == 38
      app.state.controls.up = false
    if e.keyCode == 39
      app.state.controls.right = false
    if e.keyCode == 40
      app.state.controls.down = false
  , false
