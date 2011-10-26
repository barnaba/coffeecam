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
