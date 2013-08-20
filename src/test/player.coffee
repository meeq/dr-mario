# Core libs
{stringKeyCode} = require 'core/events'
# App models
GameState = require './models/game-state'
PlayerInput = require './models/player-input'
# App views
TableView = require './views/table'

defaultControls = ->
  'Move Left':      stringKeyCode 'left'
  'Move Right':     stringKeyCode 'right'
  'Flip Left':      stringKeyCode 'Z'
  'Flip Right':     stringKeyCode 'X'
  'Fast Drop':      stringKeyCode 'down'
  'Instant Drop':   stringKeyCode 'up'
  'Hold Next':      stringKeyCode 'shift'
  'Flip Attack':    stringKeyCode 'ctrl'

module.exports = class Player
  constructor: (@number, controls) ->
    @state = new GameState
    @state.reset()
    @controls = controls ? defaultControls()
    @view = new TableView @state
    return
  render: ->
    @el = document.createElement 'li'
    @el.className = 'player'
    @el.appendChild @view.render()
    @el
  destroy: ->
    # Clean up child view
    @view?.destroy()
    delete @view
    # Clean up the DOM
    @el?.parentNode?.removeChild @el
    delete @el
    delete @state
    return
  tick: ->
    @state.tick()
    @view.update()
    return
  actionFromEvent: (event) ->
    control = key for key, val of @controls when val is event.which
    PlayerInput.actionFromString control if control?
  handleKeyDown: (event) ->
    if action = @actionFromEvent event
      if action & PlayerInput.INSTANT_ACTIONS
        @state.capsule.applyInput action
      true
    else false
  handleKeyUp: (event) ->
    return
