namespace "coffeecam", (exports) ->
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
      [ tfl, tbl, tbr, tfr ], # top
      [ bfl, bbl, bbr, bfr ], # bottom
      [ tfl, tbl, bbl, bfl ], # left
      [ tfr, tbr, bbr, bfr ], # right
      [ tfl, tfr, bfr, bfl ], # front
      [ tbl, tbr, bbr, bbl ]  # back
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
    ret.push  [$V([200, 1500, 100, 1]), $V([800, 1500, 100, 1]), $V([800, 1900, 100, 1]), $V([200, 1900, 100, 1])]
    ret.push  [$V([0, 0, 0, 1]), $V([0, 2000, 0, 1]), $V([300, 2000, 300, 1]), $V([300, 0, 300, 1])]
    ret
