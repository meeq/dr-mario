# Core libs
{stringKeyCode} = require 'core/events'
# App models
Game = require './models/game'
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
    @game = new Game
    @game.reset()
    @controls = controls ? defaultControls()
    @view = new TableView @game
    return
  destroy: ->
    @view.destroy() if @view?
    delete @view
    delete @game
    return
  tick: ->
    @game.tick()
    @view.update()
    return
  actionFromEvent: (event) ->
    control = key for key, val of @controls when val is event.which
    PlayerInput.actionFromString control if control?
  handleKeyDown: (event) ->
    if action = @actionFromEvent event
      if action & PlayerInput.INSTANT_ACTIONS
        @game.capsule.applyInput action
      true
    else false
  handleKeyUp: (event) ->
    return
