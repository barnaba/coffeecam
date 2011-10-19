$(document).ready ->
  viewport = {
    left : -500,
    right: 500,
    bottom: -500,
    top: 500,
    near: 800,
    far: 10000
  }
  canvas = document.getElementById("canvas")
  polygons = coffeecam.getScene()
  cam = new coffeecam.Camera(polygons, canvas, viewport)
  cam.move($V([0,2000,-1000]))

  move = 200
  rotation_step = 0.1

  new coffeecam.Controller
    "d": -> cam.move($V([move,0,0]))
    "q": -> cam.move($V([0,move,0]))
    "w": -> cam.move($V([0,0,move]))
    "a": -> cam.move($V([-move,0,0]))
    "s": -> cam.move($V([0,0,-move]))
    "z": -> cam.move($V([0,-move,0]))
    #arrows
    38: -> cam.rotateX(rotation_step)
    40: -> cam.rotateX(-rotation_step)
    39: -> cam.rotateY(rotation_step)
    37: -> cam.rotateY(-rotation_step)
    # home + end
    35: -> cam.rotateZ(rotation_step)
    36: -> cam.rotateZ(-rotation_step)

    "1": -> cam.change_zoom(1.1)
    "2": -> cam.change_zoom(1/1.1)



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

