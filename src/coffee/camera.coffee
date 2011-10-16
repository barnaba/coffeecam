namespace "coffeecam", (exports) ->
  class Camera
    constructor: (polygons) ->
      @polygons = polygons
      @translation = Matrix.I(4)
      @viewport = {
        left : -400,
        right: 400,
        bottom: -300,
        top: 300,
        near: 5,
        far: 800 
      }
      @zoom = 1


    move: (v) ->
      matrix = $M([
        [1,0,0,v.e(1)],
        [0,1,0,v.e(2)],
        [0,0,1,v.e(3)],
        [0,0,0,1],
      ])
      @translation = matrix.x(@translation)
      this.draw()

    rotate_x: (rad) ->
      matrix = $M([
        [1,0,0,0],
        [0,Math.cos(rad),-Math.sin(rad),0],
        [0,Math.sin(rad), Math.cos(rad),0],
        [0,0,0,1],
      ])
      @translation = matrix.x(@translation)
      this.draw()

    rotate_y: (rad) ->
      matrix = $M([
        [Math.cos(rad),0,Math.sin(rad),0],
        [0,1,0,0],
        [-Math.sin(rad),0,Math.cos(rad),0],
        [0,0,0,1],
      ])
      @translation = matrix.x(@translation)
      this.draw()

    rotate_z: (rad) ->
      matrix = $M([
        [Math.cos(rad),-Math.sin(rad),0,0],
        [Math.sin(rad),Math.cos(rad),0,0],
        [0,0,1,0],
        [0,0,0,1],
      ])
      @translation = matrix.x(@translation)
      this.draw()

    change_zoom: (z) ->
      @zoom *= z
      this.draw()

    drawPolygon : (ctx, polygon) ->
        ctx.beginPath()
        last = (polygon.length - 1)
        ctx.moveTo(polygon[last].e(1)*400 + 400, polygon[last].e(2)*300 + 300)
        ctx.lineTo(polygon[0].e(1)*400 + 400, polygon[0].e(2)*300 + 300)
        ctx.stroke()
        for point in polygon
          ctx.lineTo(point.e(1)*400 + 400, point.e(2)*300 + 300)
          console.log "#{point.e(1)}, #{point.e(2)}"
          ctx.stroke()

    draw : ->
      this.project()
      canvas = document.getElementById("canvas")
      ctx = canvas.getContext("2d")
      ctx.clearRect(0,0,800,600)
      ctx.strokeStyle = "#00FF00"
      for polygon in @projectedPolygons
        this.drawPolygon(ctx, polygon)

    project: ->
      translatedPolygons = (this.translate(polygon) for polygon in @polygons)
      @projectionMatrix = this.calculateProjectionMatrix()
      @projectedPolygons = (this.projectPolygon(polygon) for polygon in translatedPolygons)

    translate: (polygon) ->
      (@translation.x(point) for point in polygon)

    projectPolygon: (polygon) ->
      (this.normalize(@projectionMatrix.x(point)) for point in polygon)

    calculateProjectionMatrix: ->
      # mostly constant variables (except zoom). Consider not calculating this every frame :-)
      $M([
        [2*@viewport.near/(@viewport.right - @viewport.left)*@zoom, 0, (@viewport.right + @viewport.left)/(@viewport.right - @viewport.left), 0],
        [0, 2*@viewport.near/(@viewport.top - @viewport.bottom)*@zoom, (@viewport.top + @viewport.bottom)/(@viewport.top - @viewport.bottom), 0],
        [0, 0, -(@viewport.far + @viewport.near)/(@viewport.far - @viewport.near), (-2 * @viewport.far * @viewport.near)/(@viewport.far - @viewport.near)],
        [0,0,-1,0],
      ])

    normalize: (vector) ->
      w = 1/vector.e(vector.dimensions())
      vector.multiply(w)

  exports.Camera = Camera
