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

  exports.normalize = normalize
