class Controller
  constructor: (keymap) ->
    $(document).keypress (event) ->
      char = String.fromCharCode event.charCode
      key = event.keyCode
      console.log key
      if char of keymap
        keymap[char]()
      else if key of keymap
        keymap[key]()
      else
        return true
      return false

window.namespace "coffeecam", (exports) ->
  exports.Controller = Controller
