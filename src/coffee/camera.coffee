namespace "coffeecam", (exports) ->

  class Camera

    constructor: (@polygons, @canvas, @viewport) ->
      @ctx = @canvas.getContext("2d")
      @ctx.strokeStyle = "#15abc3"

      @zoom = 1
      @transformation = Matrix.I(4)
      @projectionMatrix = this.calculateProjectionMatrix()

      @move = this.decorateTransformation(moveTransformation)
      @rotateX = this.decorateTransformation(rotateXTransformation)
      @rotateY = this.decorateTransformation(rotateYTransformation)
      @rotateZ = this.decorateTransformation(rotateZTransformation)

      this.update()

    decorateTransformation : (transformation) ->
      return (args...) ->
        matrix = transformation(args...)
        @transformation = matrix.x(@transformation)
        this.update()

    change_zoom: (z) ->
      if 0.5 < @zoom*z < 3
        @zoom *= z
      @projectionMatrix = this.calculateProjectionMatrix()
      this.update()

    update: ->
      @ctx.clearRect(0,0,@canvas.width,@canvas.height)

      translatedPolygons = (this.translate(polygon) for polygon in @polygons)
      projectedPolygons = (this.projectPolygon(polygon) for polygon in translatedPolygons)
      for polygon in projectedPolygons
        this.drawPolygon(@ctx, polygon)

    translate: (polygon) ->
      (@transformation.x(point) for point in polygon)

    projectPolygon: (polygon) ->
      (normalize(@projectionMatrix.x(point)) for point in polygon)

    drawPolygon: (ctx, polygon) ->
        last = (polygon.length)
        for i in [0...last]
          current = polygon[i]
          next = polygon[(i + 1)%last]
          this.drawLineIfValid(ctx, current, next)

    drawLineIfValid : (ctx, v1, v2) ->
      [x1, y1, z1] = v1.elements
      [x2, y2, z2] = v2.elements

      if ( -1 < z1 < 1 and -1 < z2 < 1)
        h = @canvas.height / 2
        w = @canvas.width / 2

        ctx.beginPath()
        ctx.moveTo(x1*w + w, y1*h + h)
        ctx.lineTo(x2*w + w, y2*h + h)
        ctx.stroke()

    calculateProjectionMatrix: ->
      $M([
        [2*@viewport.near/(@viewport.right - @viewport.left)*@zoom, 0, (@viewport.right + @viewport.left)/(@viewport.right - @viewport.left), 0],
        [0, 2*@viewport.near/(@viewport.top - @viewport.bottom)*@zoom, (@viewport.top + @viewport.bottom)/(@viewport.top - @viewport.bottom), 0],
        [0, 0, (@viewport.far + @viewport.near)/(@viewport.far - @viewport.near), (2 * @viewport.far * @viewport.near)/(@viewport.far - @viewport.near)],
        [0,0,-1,0],
      ])

    normalize = (vector) ->
      w = 1/vector.e(vector.dimensions())
      vector.multiply(w)


    moveTransformation = (v) ->
      matrix = $M([
        [1,0,0,v.e(1)],
        [0,1,0,v.e(2)],
        [0,0,1,v.e(3)],
        [0,0,0,1],
      ])

    rotateXTransformation = (rad) ->
      matrix = $M([
        [1,0,0,0],
        [0,Math.cos(rad),-Math.sin(rad),0],
        [0,Math.sin(rad), Math.cos(rad),0],
        [0,0,0,1],
      ])

    rotateYTransformation = (rad) ->
      matrix = $M([
        [Math.cos(rad),0,Math.sin(rad),0],
        [0,1,0,0],
        [-Math.sin(rad),0,Math.cos(rad),0],
        [0,0,0,1],
      ])

    rotateZTransformation = (rad) ->
      matrix = $M([
        [Math.cos(rad),-Math.sin(rad),0,0],
        [Math.sin(rad),Math.cos(rad),0,0],
        [0,0,1,0],
        [0,0,0,1],
      ])

  exports.Camera = Camera
