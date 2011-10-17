$(document).ready ->
  viewport = {
    left : -400,
    right: 400,
    bottom: -300,
    top: 300,
    near: 300,
    far: 8000
  }
  canvas = document.getElementById("canvas")
  polygons = coffeecam.getScene()
  cam = new coffeecam.Camera(polygons, canvas, viewport)
  cam.move($V([0,2000,-1000]))

  move = 20
  rotation_step = 0.05


  #demo stuff 
 
  i = 0
  dir = true
  max = 200

  window.demo1 = ->
    cam.move($V([130,0,0]))
    cam.rotateY(0.03)
    setTimeout demo1, 3

  window.demo2 = ->
    if (dir)
      cam.move($V([0,0,50]))
      cam.rotateZ(Math.PI/100)
    else
      cam.rotateX(Math.PI/50)
    if (i++>=max)
      i=0
      dir=!dir
      max = (if dir then 200 else 50)
      console.log max
    setTimeout demo2, 10
    
  friction = 0.9
  rotfriction = 0.7
  x = y = z = rx = ry = rz = 0

  do tick = ->
    cam.move($V([x,y,z]))
    cam.rotateX(rx)
    cam.rotateY(ry)
    cam.rotateZ(rz)

    x *= friction
    y *= friction
    z *= friction

    rx *= rotfriction
    ry *= rotfriction
    rz *= rotfriction

    setTimeout tick, 5

  new coffeecam.Controller
    "d": -> x -= move
    "a": -> x += move
    "s": -> z -= move
    "w": -> z += move
    "z": -> y -= move
    "q": -> y += move
    #arrows
    38: -> rx += rotation_step
    40: -> rx -= rotation_step
    39: -> ry += rotation_step
    37: -> ry -= rotation_step
    # home + end
    35: -> rz += rotation_step
    36: -> rz -= rotation_step

    "1": -> cam.change_zoom(1.1)
    "2": -> cam.change_zoom(1/1.1)

