class Controller
  constructor: (keymap) ->
    $(document).keypress (event) ->
      char = String.fromCharCode event.charCode
      key = event.keyCode

      if char of keymap
        keymap[char]()
        return false
      else if key of keymap
        keymap[key]()
        return false

window.namespace "coffeecam", (exports) ->
  exports.Controller = Controller
