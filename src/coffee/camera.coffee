namespace "coffeecam", (exports) ->

  class Camera

    constructor: (@polygons, @canvas, @viewport) ->
      @ctx = @canvas.getContext("2d")
      @ctx.strokeStyle = "#15abc3"
      @ctx.fillStyle = "#000000"

      @zoom = 1
      @transformation = $M([
        [-1,0,0,0],
        [0,-1,0,0],
        [0,0,-1,0],
        [0,0,0,1]
      ])
      @cameraInScene = this.calculatePositionInScene()
      @projectionMatrix = this.calculateProjectionMatrix()

      @move = this.decorateTransformation(moveTransformation)
      @rotateX = this.decorateTransformation(rotateXTransformation)
      @rotateY = this.decorateTransformation(rotateYTransformation)
      @rotateZ = this.decorateTransformation(rotateZTransformation)

      @h = @canvas.height / 2
      @w = @canvas.width / 2

      this.update()

    decorateTransformation : (transformation) ->
      return (args...) ->
        matrix = transformation(args...)
        @transformation = matrix.x(@transformation)
        @cameraInScene = this.calculatePositionInScene()
        this.update()

    change_zoom: (z) ->
      if 0.5 < @zoom*z < 3
        @zoom *= z
      @projectionMatrix = this.calculateProjectionMatrix()
      this.update()

    update: ->
      @ctx.clearRect(0,0,@canvas.width,@canvas.height)
      @projectionTransformationMatrix = @projectionMatrix.x(@transformation)
      for polygon in @polygons
        polygon.d = this.distanceFromCamera(polygon)
      @polygons = @polygons.sort(distanceComparator)

      projectedPolygons = (this.projectPolygon(polygon) for polygon in @polygons)
      projectedPolygons = (polygon for polygon in projectedPolygons when visible(polygon))

      for polygon in projectedPolygons
        this.drawPolygon(@ctx, polygon)

    projectPolygon: (polygon) ->
      (normalize(@projectionTransformationMatrix.x(point)) for point in polygon)

    drawPolygon: (ctx, polygon) ->
        last = (polygon.length)

        ctx.beginPath()
        ctx.moveTo(polygon[0].e(1)*@w + @w, polygon[0].e(2)*@h + @h)

        for i in [0...last]
          current = polygon[i]
          next = polygon[(i + 1)%last]
          this.drawLine(ctx, next)
        ctx.fill()
        ctx.stroke()

    drawLine: (ctx, v1) ->
      [x2, y2, z2] = v1.elements
      ctx.lineTo(x2*@w + @w, y2*@h + @h)

    calculatePositionInScene : ->
      normalize(@transformation.inverse().x($V([0,0,0,1])))

    calculateProjectionMatrix: ->
      $M([
        [2*@viewport.near/(@viewport.right - @viewport.left)*@zoom, 0, (@viewport.right + @viewport.left)/(@viewport.right - @viewport.left), 0],
        [0, 2*@viewport.near/(@viewport.top - @viewport.bottom)*@zoom, (@viewport.top + @viewport.bottom)/(@viewport.top - @viewport.bottom), 0],
        [0, 0, (@viewport.far + @viewport.near)/(@viewport.far - @viewport.near), (2 * @viewport.far * @viewport.near)/(@viewport.far - @viewport.near)],
        [0,0,-1,0],
      ])


    # Compare two polygons by the distance between their barycenter and camera

    distanceComparator = (p1, p2) =>
      p2.d - p1.d

    # Calculate distance between polygon's barycenter and the camera

    distanceFromCamera: (polygon) =>
      reduceFunction = (barycenter, point) -> barycenter.add(point)
      barycenter = polygon.reduce(reduceFunction, $V([0,0,0,0])).multiply(1/polygon.length)
      return @cameraInScene.subtract(barycenter).modulus()

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

    visible = (polygon) ->
      polygon.reduce (result, point) -> result and (-1 < point.e(3) < 1)

  exports.Camera = Camera
