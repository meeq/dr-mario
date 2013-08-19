{eventCharacter} = require 'core/events'

module.exports = class Setup
  template: require './templates/setup'
  constructor: ({@players}) ->
    return
  render: ->
    @el = document.createElement 'div'
    @el.id = 'setup'
    @el.innerHTML = @template @
    # Update range elements when value changes
    for rangeEl in @el.querySelectorAll '[type=range]'
      rangeEl.addEventListener 'change', @levelChanged
    # Set initial key bindings, bind events
    for buttonEl in @el.querySelectorAll '.controls button'
      playerNum = buttonEl.form.name[1..]
      player = @players[playerNum - 1]
      keyCode = player.controls[buttonEl.name]
      keyChar = eventCharacter keyCode
      buttonEl.textContent = keyChar
    @el
  destroy: ->
    @el?.parentNode?.removeChild @el
    delete @el
    return
  levelChanged: (event) ->
    el = event.target
    el.setAttribute 'value', el.value
    return
