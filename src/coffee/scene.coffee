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

    row = (blocks, startX=0, startY=0, startZ=0) ->
      ( for i in [0...blocks]
        getPolygonsForCuboid(startX, startY, startZ + depthMax*i*1.1, do width, do height, do depth))

    ret = [].concat row(15, -3200)... , row(15, -800)... , row(15, 800)... , row(15, 3200)...

   #  polygons demostrating some problems with painters algorithm
    #ret.push  [$V([200, 1500, 100, 1]), $V([800, 1500, 100, 1]), $V([800, 1900, 100, 1]), $V([200, 1900, 100, 1])]
    #ret.push  [$V([0, 0, 0, 1]), $V([0, 2000, 0, 1]), $V([300, 2000, 300, 1]), $V([300, 0, 300, 1])]
    ret.push new Sphere(point(0,1000,0), 150)
    ret.push new Sphere(point(0,1400,0), 150)
    ret.push new Sphere(point(0,600,0), 150)
    ret

  class Polygon
    constructor: (@points...) ->

    barycenter: ->
      reduceFunction = (barycenter, point) -> barycenter.add(point)
      @points.reduce(reduceFunction, $V([0,0,0,0])).multiply(1/@points.length)

    is_visible : ->
      @points.reduce (result, point) -> result and (-1 < point.e(3) < 1)

    transform : (camera) ->
      transformation_matrix = camera.projectionTransformationMatrix
      points = (normalize(transformation_matrix.x(point)) for point in @points)
      polygon = new Polygon(points...)
      polygon.d = @d
      polygon

    draw: (ctx) ->

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
    constructor: (@center, @radius) ->

    transform : (camera) ->
      transformation_matrix = camera.projectionTransformationMatrix
      console.log ("this.d:" )
      console.log(this.d)
      @projected_center = normalize(transformation_matrix.x(@center))
      @projected_radius = ( @radius * camera.viewport.near )/(camera.viewport.near + this.d)
      this

    is_visible : -> true

    barycenter : -> @center

    draw : (ctx) ->
      ctx.beginPath()
      ctx.arc(@projected_center.e(1), @projected_center.e(2), @projected_radius, 0, Math.PI*2, true)
      ctx.closePath()
      ctx.fill()
      ctx.stroke()


  exports.Polygon = Polygon
