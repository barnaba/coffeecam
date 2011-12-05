window.namespace = (target, name, block) ->
  [target, name, block] = [(if typeof exports isnt 'undefined' then exports else window), arguments...] if arguments.length < 3
  top    = target
  target = target[item] or= {} for item in name.split '.'
  block target, top

namespace "coffeecam", (exports) ->
  exports.point = (x, y, z) ->
    $V([x,y,z,1])

  normalize = (vector) ->
    w = 1/vector.e(4)
    vector.multiply(w)
    return vector

  class Polygon
    constructor: (@points...) ->

    barycenter: ->
      reduceFunction = (barycenter, point) -> barycenter.add(point)
      @points.reduce(reduceFunction, $V([0,0,0,0])).multiply(1/@points.length)

    is_visible : ->
      #@points.reduce (result, point) -> result and (-1 < point.e(3) < 1)
      true

    transform : (matrix) ->
      points = (normalize(matrix.x(point)) for point in @points)
      polygon = new Polygon(points...)
      polygon.d = @d
      polygon

  exports.Polygon = Polygon
  exports.normalize = normalize
