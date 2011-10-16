namespace "coffeecam", (exports) ->

  getPolygonsForCuboid = (x,y,z,w,h,d) ->
    xw = x + w
    yh = y + h
    zd = z + d

    [
      [
        $V([x, yh, z, 1]),
        $V([x, yh, zd, 1]),
        $V([x, y, zd, 1]),
        $V([x, y, z, 1])
      ],
      [
        $V([xw, yh, z, 1]),
        $V([xw, yh, zd, 1]),
        $V([xw, y, zd, 1]),
        $V([xw, y, z, 1])
      ],
      [
        $V([x, y, z, 1]),
        $V([xw, y, z, 1]),
        $V([xw, y, zd, 1]),
        $V([x, y, zd, 1])
      ],
      [
        $V([x, yh, z, 1]),
        $V([xw, yh, z, 1]),
        $V([xw, yh, zd, 1]),
        $V([x, yh, zd, 1])
      ],
      [
        $V([x, yh, z, 1]),
        $V([xw, yh, z, 1]),
        $V([xw, y, z, 1]),
        $V([x, y, z, 1])
      ],
      [
        $V([x, yh, zd, 1]),
        $V([xw, yh, zd, 1]),
        $V([xw, y, zd, 1]),
        $V([x, y, zd, 1])
      ]
    ]

  exports.getScene = ->
    polygons = []
    polygons.push getPolygonsForCuboid(-100,-100,500,200,200,100)
    polygons.push getPolygonsForCuboid(100,-100,502,200,200,100)
    polygons.push getPolygonsForCuboid(-100,100,500,200,200,100)
    [].concat polygons...
