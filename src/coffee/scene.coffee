namespace "coffeecam", (exports) ->
  normalize = coffeecam.normalize
  point = coffeecam.point

  getPolygonsForCuboid = (x,y,z,w,h,d) ->
    xw = x + w
    yh = y + h
    zd = z + d

    tfl = point(x  , yh , zd)
    tbl = point(x  , yh , z )
    tfr = point(xw , yh , zd)
    tbr = point(xw , yh , z )
    bfl = point(x  , y  , zd)
    bbl = point(x  , y  , z )
    bfr = point(xw , y  , zd)
    bbr = point(xw , y  , z )

    [
      new coffeecam.Polygon( tfl, tbl, tbr, tfr ), # top
      new coffeecam.Polygon( bfl, bbl, bbr, bfr ), # bottom
      new coffeecam.Polygon( tfl, tbl, bbl, bfl ), # left
      new coffeecam.Polygon( tfr, tbr, bbr, bfr ), # right
      new coffeecam.Polygon( tfl, tfr, bfr, bfl ), # front
      new coffeecam.Polygon( tbl, tbr, bbr, bbl )  # back
    ]

  exports.getScene = (depthMax=1000) ->

    randomVal = (min=0, max=1) ->
      return -> min + Math.random() * (max - min)

    depth = randomVal(200, depthMax)
    height = randomVal(200, 1000)
    width = -> 200

    row = (blocks, startX=0, startY=0, startZ=1500) ->
      ( for i in [0...blocks]
        getPolygonsForCuboid(startX, startY, startZ + depthMax*i*1.1, do width, do height, do depth))

    ret = [].concat row(2, -3200)... , row(2, -800)... , row(2, 800)... , row(2, 3200)...
    ret.push new Sphere(point(5000,1000,9000), 500, [100, 100, 31, 0.05], [0,255,0])
    ret.push new Sphere(point(-5000,1000,9000), 500, [300, 0.1, 0.3, 0.05], [255,0,0])
    ret.push new Sphere(point(1,2000,8000), 100, [0, 0, 0, 9], [255,255,0]) # sun :-)
    ret

  class Polygon
    constructor: (@points...) ->

    barycenter: ->
      reduceFunction = (barycenter, point) -> barycenter.add(point)
      @points.reduce(reduceFunction, $V([0,0,0,0])).multiply(1/@points.length)

    is_visible : ->
      @points.reduce (result, point) -> result and (-1 < point.e(3) < 1)

    transform : (camera) ->
      transformation_matrix = camera.scaling.x camera.projectionTransformationMatrix
      points = (normalize(transformation_matrix.x(point)) for point in @points)
      polygon = new Polygon(points...)
      polygon.d = @d
      polygon

    draw: (camera) ->
      ctx = camera.ctx

      last = (@points.length)

      ctx.beginPath()
      ctx.moveTo(@points[0].e(1), @points[0].e(2))

      for i in [0...last]
        current = @points[i]
        next = @points[(i + 1)%last]
        drawLine(ctx, next)
      ctx.fill()
      ctx.stroke()

    drawLine = (ctx, to) ->
      [x2, y2, z2] = to.elements
      ctx.lineTo(x2, y2)

  class Sphere
    constructor: (@center, @radius, lights, @color) ->
      @diffusePower = lights[0]
      @specularPower = lights[1]
      @specularHardness = lights[2]
      @ambientPower = lights[3]

    transform : (camera) ->
      transformation_matrix = camera.scaling.x camera.projectionTransformationMatrix
      inv = transformation_matrix.inverse()
      @projected_center = normalize(transformation_matrix.x(@center))
      @projected_radius = ( @radius * camera.viewport.near )/(this.d)
      c = @projected_center
      h = $V([@projected_radius,0,0,0])
      w = $V([0,@projected_radius,0,0])
      tl = c.subtract(h).subtract(w)
      br = c.add(h).add(w)
      @hooking_point = tl
      @x_pixels = Math.abs(br.e(1) - tl.e(1))
      @y_pixels = Math.abs(br.e(2) - tl.e(2))
      @bounding_tl = normalize(camera.transformation.x inv.x($V([tl.e(1), tl.e(2), 1, 1])))
      @bounding_br = normalize(camera.transformation.x inv.x($V([br.e(1), br.e(2), 1, 1])))

      this

    is_visible : ->
      @projected_center.e(1) < 500 and
      @projected_center.e(1) > 0   and
      @projected_center.e(2) < 500 and
      @projected_center.e(2) > 0   and
      @x_pixels < 500              and
      @y_pixels < 500
      true

    barycenter : -> @center

    draw : (camera) ->
      @transformed_center = normalize(camera.transformation.x @center)
      ctx = camera.ctx

      @step_x = (@bounding_br.e(1) - @bounding_tl.e(1)) / @x_pixels
      @step_y = (@bounding_br.e(2) - @bounding_tl.e(2)) / @y_pixels

      data = ctx.getImageData(@hooking_point.e(1), @hooking_point.e(2), @x_pixels, @y_pixels)
      window.once = true
      for y in [1..@y_pixels]
        for x in [1..@x_pixels]
          pixel_colors = this.castRay(x, y, camera)
          if pixel_colors
            setPixel(data, x, y, pixel_colors..., 256)
      ctx.putImageData(data, @hooking_point.e(1), @hooking_point.e(2))

    castRay : (x, y, camera) ->
      x2 = @bounding_br.e(1) - @step_x * x
      y2 = @bounding_br.e(2) - @step_y * y
      z2 = @bounding_br.e(3)
      x3 = @transformed_center.e(1)
      y3 = @transformed_center.e(2)
      z3 = @transformed_center.e(3)

      a = x2*x2 + y2*y2 + z2*z2
      b = -2 * (x2*x3 + y2*y3 + z2*z3)
      c = x3*x3 + y3*y3 + z3*z3 - @radius*@radius
      
      delta = b*b - 4 * a * c

      if delta >= 0
        s = ( b - Math.sqrt(delta) ) / (2 * a)
        thisPoint= $V([s*x2, -s*y2, -s*z2])
        center = $V([-x3, y3, z3])
        light = camera.lightsource

        normal = (thisPoint.subtract center).toUnitVector()
        light_dir = thisPoint.subtract light
        distance = Math.pow(light_dir.modulus()*0.003,2)
        view_dir = thisPoint.toUnitVector()
        h = light_dir.add(view_dir).toUnitVector()
        light_dir = light_dir.toUnitVector()

        lightning = 0
        lightning += saturate(0, 1, light_dir.dot(normal) * @diffusePower / distance)
        lightning += saturate(0,1, Math.pow(h.dot(normal), @specularHardness) * @specularPower / distance)
        lightning += @ambientPower

        lightColors= (color) ->
          color * (saturate(0,1,lightning))
        @color.map(lightColors)
      else
        false


  setPixel = (imageData, x, y, r, g, b, a) ->
    index = (x + y * imageData.width) * 4
    imageData.data[index+0] = r
    imageData.data[index+1] = g
    imageData.data[index+2] = b
    imageData.data[index+3] = a

  debug = (v) ->
    arr = [v.e(1), v.e(2), v.e(3)]
    pretty = (x) -> x.toPrecision(5)
    arr.map(pretty).join(" | ")
    


  saturate = (min, max, arg) ->
    if arg < min
      min
    else if arg > max
      max
    else
      arg
      
  moveTransformation = (v) ->
    matrix = $M([
      [1,0,0,v.e(1)],
      [0,1,0,v.e(2)],
      [0,0,1,v.e(3)],
      [0,0,0,1],
    ])
    

  exports.Polygon = Polygon
