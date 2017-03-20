# App models
PlayerInput = require '../models/player-input'

buttonActions =
  'back': PlayerInput.NONE
  'pause': PlayerInput.NONE
  'retry': PlayerInput.NONE
  'move-left': PlayerInput.MOVE_LEFT
  'move-right': PlayerInput.MOVE_RIGHT
  'fast-drop': PlayerInput.FAST_DROP
  'flip-left': PlayerInput.FLIP_LEFT
  'flip-right': PlayerInput.FLIP_RIGHT

module.exports = class PlayerTouchControlsView
  constructor: ({@app, @game, @player}) ->
    return
  render: ->
    @el = document.createElement 'div'
    @el.id = 'player-touch-controls'
    # Create button elements
    for name, action of buttonActions
      buttonEl = document.createElement 'button'
      buttonEl.name = name
      buttonEl.innerText = name.replace '-', ' '
      @el.appendChild buttonEl
    # Register touch event listeners
    @el.addEventListener 'touchstart', @handleTouchStart
    @el.addEventListener 'touchend', @handleTouchEnd
    @el
  destroy: ->
    # Unregister touch event listeners
    @el.removeEventListener 'touchstart', @handleTouchStart
    @el.removeEventListener 'touchend', @handleTouchEnd
    # Clean up the DOM
    @el?.parentNode?.removeChild @el
    delete @el
    return
  handleTouchStart: (event) =>
    event.preventDefault()
    return unless name = event.target.name
    switch name
      when 'back'
        @app.showSetup()
      when 'pause'
        @game.togglePaused()
      when 'retry'
        @game.reset()
      else
        @player.beginAction buttonActions[name]
    return
  handleTouchEnd: (event) =>
    return unless name = event.target.name
    @player.endAction buttonActions[name]
    return
