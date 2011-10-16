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
    polygons.push getPolygonsForCuboid(-100,-100,30,200,200,1)
    polygons.push getPolygonsForCuboid(100,-100,32,200,200,1)
    polygons.push getPolygonsForCuboid(-100,100,30,200,200,1)
    [].concat polygons...
