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
  cam.move($V([0,1000,-1000]))
  cam.rotateX(-0.2)

  move = 20
  rotation_step = 0.08

  new coffeecam.Controller
    "d": -> cam.move($V([-move,0,0]))
    "a": -> cam.move($V([move,0,0]))
    "s": -> cam.move($V([0,0,-move]))
    "w": -> cam.move($V([0,0,move]))
    "z": -> cam.move($V([0,-move,0]))
    "q": -> cam.move($V([0,move,0]))
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
