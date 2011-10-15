namespace "coffeecam", (exports) ->
  class Camera
    constructor: (polygons) ->
      @polygons = polygons
      @translation = Matrix.I(4)
      @viewport = {
        left : 0,
        right: 800,
        bottom: 0,
        top: 600,
        near: 100,
        far: 2
      }


    move: (v) ->
      matrix = $M([
        [1,0,0,v.e(1)],
        [0,1,0,v.e(2)],
        [0,0,1,v.e(3)],
        [0,0,0,1],
      ])
      @translation = @translation.x(matrix)
      this.draw()

    rotate_x: (rad) ->
      matrix = $M([
        [1,0,0,0],
        [0,Math.cos(rad),-Math.sin(rad),0],
        [0,Math.sin(rad), Math.cos(rad),0],
        [0,0,0,1],
      ])
      @translation = @translation.x(matrix)
      this.draw()

    rotate_y: (rad) ->
      matrix = $M([
        [Math.cos(rad),0,Math.sin(rad),0],
        [0,1,0,0],
        [-Math.sin(rad),0,Math.cos(rad),0],
        [0,0,0,1],
      ])
      @translation = @translation.x(matrix)
      this.draw()

    rotate_z: (rad) ->
      matrix = $M([
        [Math.cos(rad),-Math.sin(rad),0,0],
        [Math.sin(rad),Math.cos(rad),0,0],
        [0,0,1,0],
        [0,0,0,1],
      ])
      @translation = @translation.x(matrix)
      this.draw()

    drawPolygon : (ctx, polygon) ->
        ctx.beginPath()
        last = (polygon.length - 1)
        ctx.moveTo(polygon[last].e(1), polygon[last].e(2))
        ctx.lineTo(polygon[0].e(1), polygon[0].e(2))
        ctx.stroke()
        console.log("Drawing from #{polygon[0].e(1)},#{polygon[0].e(2)}")
        for point in polygon
          ctx.lineTo(point.e(1), point.e(2))
          console.log("stroke to #{point.e(1)},#{point.e(2)}")
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
      (this.normalize(@translation.x(point)) for point in polygon)

    projectPolygon: (polygon) ->
      (@projectionMatrix.x(point) for point in polygon)
      (@projectionMatrix.x(point) for point in polygon)

    calculateProjectionMatrix: ->
      $M([
        [2*@viewport.near/(@viewport.right - @viewport.left), 0, (@viewport.right + @viewport.left)/(@viewport.right - @viewport.left), 0],
        [0, 2*@viewport.near/(@viewport.top - @viewport.bottom), (@viewport.top + @viewport.bottom)/(@viewport.top - @viewport.bottom), 0],
        [0, 0, -(@viewport.far + @viewport.near)/(@viewport.far - @viewport.near), (-2 * @viewport.far * @viewport.near)/(@viewport.far - @viewport.near)],
        [0,0,-1,0],
      ]).transpose()

    normalize: (vector) ->
      vector.multiply(vector.e(vector.dimensions()))

  exports.Camera = Camera
