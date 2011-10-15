namespace = (target, name, block) ->
  [target, name, block] = [(if typeof exports isnt 'undefined' then exports else window), arguments...] if arguments.length < 3
  top    = target
  target = target[item] or= {} for item in name.split '.'
  block target, top

namespace "ee.Coffeecam", (exports) ->
  exports.getScene = ->
    console.log "cze"

  #{
    #cuboids : [
      #[
        #$V(0,0,0),
        #$V(1,1,1),
        #$V(2,2,2),
        #$V(3,3,3)
      #],
    #]
  #}
