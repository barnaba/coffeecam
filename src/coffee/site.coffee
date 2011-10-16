$(document).ready ->
  cam = new coffeecam.Camera(window.coffeecam.getScene())
  cam.move($V([0,1000,-1000]))
  cam.rotate_x(-0.2)
  cam.draw()

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
    38: -> cam.rotate_x(rotation_step)
    40: -> cam.rotate_x(-rotation_step)
    39: -> cam.rotate_y(rotation_step)
    37: -> cam.rotate_y(-rotation_step)
    # home + end
    35: -> cam.rotate_z(rotation_step)
    36: -> cam.rotate_z(-rotation_step)

    "1": -> cam.change_zoom(1.1)
    "2": -> cam.change_zoom(1/1.1)
