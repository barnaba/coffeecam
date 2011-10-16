$(document).ready ->
  cam = new coffeecam.Camera(window.coffeecam.getScene())
  cam.draw()

  move = 10
  rotation_step = 0.01

  new coffeecam.Controller
    "a": -> cam.move($V([-move,0,0]))
    "d": -> cam.move($V([move,0,0]))
    "w": -> cam.move($V([0,-move,0]))
    "s": -> cam.move($V([0,move,0]))
    "q": -> cam.move($V([0,0,1]))
    "e": -> cam.move($V([0,0,-1]))
    "x": -> cam.rotate_x(rotation_step)
    "z": -> cam.rotate_z(rotation_step)
    "c": -> cam.rotate_y(rotation_step)
    "X": -> cam.rotate_x(-rotation_step)
    "Z": -> cam.rotate_z(-rotation_step)
    "C": -> cam.rotate_y(-rotation_step)
    "1": -> cam.change_zoom(1.1)
    "2": -> cam.change_zoom(1/1.1)
