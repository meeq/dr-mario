# Core libs
{stringKeyCode} = require 'core/events'
# App libs
Game = require './game'
PlayerInput = require './player-input'
TableView = require '../views/table'

defaultControls = ->
  'Move Left':      stringKeyCode 'left'
  'Move Right':     stringKeyCode 'right'
  'Flip Left':      stringKeyCode 'Z'
  'Flip Right':     stringKeyCode 'X'
  'Fast Fall':      stringKeyCode 'down'
  'Quick Drop':     stringKeyCode 'up'
  'Hold Next':      stringKeyCode 'shift'
  'Flip Attack':    stringKeyCode 'ctrl'

clearActionsAfterTick =
  PlayerInput.QUICK_DROP &
  PlayerInput.HOLD_NEXT &
  PlayerInput.FLIP_ATTACK

module.exports = class Player
  constructor: (@number, controls) ->
    @game = new Game
    @game.reset()
    @controls = controls ? defaultControls()
    @input = PlayerInput.clear()
    @view.destroy() if @view?
    @view = new TableView @game
    return
  destroy: ->
    @view.destroy() if @view?
    delete @view
    delete @game
    return
  tick: ->
    console.log "Player %d: %s", @number, PlayerInput.inputToString @input
    if @game.tick @input
      @input = PlayerInput.clear @input, clearActionsAfterTick
    @view.update()
    return
  actionFromEvent: (event) ->
    actionString = key for key, val of @controls when val is event.which
    PlayerInput.actionFromString actionString if actionString?
  handleKeyDown: (event) ->
    action = @actionFromEvent event
    @input = PlayerInput.set @input, action if action?
    return
  handleKeyUp: (event) ->
    action = @actionFromEvent event
    @input = PlayerInput.clear @input, action if action?
    return
