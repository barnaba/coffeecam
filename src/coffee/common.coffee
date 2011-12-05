window.namespace = (target, name, block) ->
  [target, name, block] = [(if typeof exports isnt 'undefined' then exports else window), arguments...] if arguments.length < 3
  top    = target
  target = target[item] or= {} for item in name.split '.'
  block target, top

namespace "coffeecam", (exports) ->
  exports.point = (x, y, z) ->
    $V([x,y,z,1])

  normalize = (vector) ->
    w = 1/vector.e(vector.dimensions())
    vector.multiply(w)

  class Polygon
    constructor: (@points...) ->

    barycenter: ->
      reduceFunction = (barycenter, point) -> barycenter.add(point)
      @points.reduce(reduceFunction, $V([0,0,0,0])).multiply(1/@points.length)

    is_visible : ->
      @points.reduce (result, point) -> result and (-1 < point.e(3) < 1)

    transform : (transformation_matrix) ->
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

  exports.Polygon = Polygon
  exports.normalize = normalize
