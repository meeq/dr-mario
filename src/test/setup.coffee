{eventCharacter} = require 'core/events'

module.exports = class Setup
  template: require './templates/setup'
  rangeSelector: '[type=range]'
  controlSelector: '.controls button'
  constructor: ({@players}) ->
    return
  render: ->
    @el = document.createElement 'div'
    @el.id = 'setup'
    @el.innerHTML = @template @
    # Update range elements when value changes
    for rangeEl in @el.querySelectorAll @rangeSelector
      rangeEl.addEventListener 'change', @levelChanged
    # Set initial key bindings, bind events
    for buttonEl in @el.querySelectorAll @controlSelector
      playerNum = buttonEl.form.name[1..]
      player = @players[playerNum - 1]
      keyCode = player.controls[buttonEl.name]
      keyChar = eventCharacter keyCode
      buttonEl.textContent = keyChar
    @el
  destroy: ->
    # Unregister event handlers
    for rangeEl in @el.querySelectorAll @rangeSelector
      rangeEl.removeEventListener 'change', @levelChanged
    # Clean up the DOM
    @el?.parentNode?.removeChild @el
    delete @el
    return
  levelChanged: (event) ->
    el = event.target
    # Set the attribute so that the pseduo-element content changes
    el.setAttribute 'value', el.value
    return
