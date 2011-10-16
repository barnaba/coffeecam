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
    for i in [0..15]
      polygons.push getPolygonsForCuboid(-800,0,i*(-1000)+2000,200,-200-Math.random()*1000,200 + Math.random()*400)
      polygons.push getPolygonsForCuboid(800,0,i*(-1000)+2000,200,-200-Math.random()*1000,200 + Math.random()*400)
    [].concat polygons...
