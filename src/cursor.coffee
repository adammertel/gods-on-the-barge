define 'Cursor', ['App', 'Base'], (app, Base) ->
  class Cursor

    getPosition: ->
      {x: (@x - (app.state.position.x)) * app.state.zoom, y: (@y - (app.state.position.y)) * app.state.zoom}

    draw: ->
      mp = app.state.controls.mousePosition

      app.ctx.beginPath();
      #app.ctx.arc(mp.x, mp.y, 5, 0, 2 * Math.PI, false);
      app.ctx.moveTo mp.x, mp.y
      app.ctx.lineTo mp.x, mp.y+10
      app.ctx.lineTo mp.x + 3, mp.y + 7
      app.ctx.lineTo mp.x + 8, mp.y + 12
      app.ctx.lineTo mp.x + 9, mp.y + 11
      app.ctx.lineTo mp.x + 4, mp.y + 6
      app.ctx.lineTo mp.x + 8, mp.y + 3
      app.ctx.closePath()
      app.ctx.fillStyle = 'black';
      app.ctx.fill();
      #app.ctx.lineWidth = 1;
      #app.ctx.strokeStyle = 'black';
      #app.ctx.stroke();
