namespace "coffeecam", (exports) ->

  class Camera

    constructor: (@objects, @canvas, @viewport, @lightsource) ->
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

      @light = coffeecam.point(1, 2000, 8000)
      @lightsource = this.lightSource()

      @h = @canvas.height / 2
      @w = @canvas.width / 2
      @scaling = $M([
        [@w,0,0,@w],
        [0,@h,0,@h],
        [0,0,1,0],
        [0,0,0,1]
      ])

      @cameraInScene = this.calculatePositionInScene()
      @projectionMatrix = this.calculateProjectionMatrix()

      @move = this.decorateTransformation(moveTransformation)
      @rotateX = this.decorateTransformation(rotateXTransformation)
      @rotateY = this.decorateTransformation(rotateYTransformation)
      @rotateZ = this.decorateTransformation(rotateZTransformation)

      this.update()

    lightSource : () ->
      v = coffeecam.normalize(@transformation.x(@light))
      $V([-v.e(1), v.e(2), v.e(3)])

    moveLight : (x, y, z) ->
      @light = @light.add $V([x, y, z, 0])
      @lightsource = this.lightSource()
      this.update()

    decorateTransformation : (transformation) ->
      return (args...) ->
        matrix = transformation(args...)
        @transformation = matrix.x(@transformation)
        @cameraInScene = this.calculatePositionInScene()
        @lightsource = this.lightSource()
        this.update()

    change_zoom: (z) ->
      if 0.5 < @zoom*z < 3
        @zoom *= z
      @projectionMatrix = this.calculateProjectionMatrix()
      this.update()

    update: ->
      @ctx.clearRect(0,0,@canvas.width,@canvas.height)
      @projectionTransformationMatrix = @projectionMatrix.x(@transformation)

      for object in @objects
        object.d = this.distanceFromCamera(object)
      @objects = @objects.sort(distanceComparator)
      projectedObjects = (o.transform(this) for o in @objects)
      visibleObjects = (o for o in projectedObjects when o.is_visible())

      for object in visibleObjects
        object.draw(this)

    calculatePositionInScene : ->
      coffeecam.normalize(@transformation.inverse().x($V([0,0,0,1])))

    calculateProjectionMatrix: ->
      $M([
        [@viewport.near/@viewport.right, 0, 0, 0],
        [0, @viewport.near/@viewport.top, 0, 0],
        [0, 0, (@viewport.far + @viewport.near)/(@viewport.far - @viewport.near), (2 * @viewport.far * @viewport.near)/(@viewport.far - @viewport.near)],
        [0,0,-1,0],
      ])

    distanceComparator = (p1, p2) =>
      p2.d - p1.d

    distanceFromCamera: (object) =>
      barycenter = object.barycenter()
      return @cameraInScene.subtract(barycenter).modulus()

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
