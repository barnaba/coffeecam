namespace "coffeecam", (exports) ->

  getPolygonsForCuboid = (x,y,z,w,h,d) ->
    xw = x + w
    yh = y + h
    zd = z + d

    tfl = $V([x  , yh , zd , 1])
    tbl = $V([x  , yh , z  , 1])
    tfr = $V([xw , yh , zd , 1])
    tbr = $V([xw , yh , z  , 1])
    bfl = $V([x  , y  , zd , 1])
    bbl = $V([x  , y  , z  , 1])
    bfr = $V([xw , y  , zd , 1])
    bbr = $V([xw , y  , z  , 1])

    [
      [ tfl, tbl, tbr, tfr ], # top
      [ bfl, bbl, bbr, bfr ], # bottom
      [ tfl, tbl, bbl, bfl ], # left
      [ tfr, tbr, bbr, bfr ], # right
      [ tfl, tfr, bfr, bfl ], # front
      [ tbl, tbr, bbr, bbl ]  # back
    ]

  exports.getScene = ->
    polygons = []
    for i in [0..15]
      polygons.push getPolygonsForCuboid(-3200,0,i*(-1000)+2000,200,-200-Math.random()*1000,200 + Math.random()*400)
      polygons.push getPolygonsForCuboid(-800,0,i*(-1000)+2000,200,-200-Math.random()*1000,200 + Math.random()*400)
      polygons.push getPolygonsForCuboid(800,0,i*(-1000)+2000,200,-200-Math.random()*1000,200 + Math.random()*400)
      polygons.push getPolygonsForCuboid(3200,0,i*(-1000)+2000,200,-200-Math.random()*1000,200 + Math.random()*400)
    [].concat polygons...
