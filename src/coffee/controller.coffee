class Controller
  constructor: (keymap) ->
    $(document).keypress (event) ->
      char = String.fromCharCode event.charCode
      keymap[char]() if char of keymap

window.namespace "coffeecam", (exports) ->
  exports.Controller = Controller
