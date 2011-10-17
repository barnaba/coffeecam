class Controller
  constructor: (keymap) ->
    $(document).keypress (event) ->
      char = String.fromCharCode event.charCode
      do keymap[char] if char of keymap

    $(document).keydown (event) ->
      if event.keyCode of keymap
        do keymap[event.keyCode]
        return false

window.namespace "coffeecam", (exports) ->
  exports.Controller = Controller
