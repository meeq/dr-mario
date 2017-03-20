# App models
PlayerInput = require '../models/player-input'
PlayerState = require '../models/player-state'
# App views
PlayerScoreboardView = require './player-scoreboard'
PlayerTableView = require './player-table'
PlayerTouchControlsView = require './player-touch-controls'

module.exports = class Player
  constructor: (@options) ->
    {@app, @game, @controls} = @options
    {@isTouchDevice} = @app
    @reset()
    return
  reset: ->
    @state = new PlayerState @options
    @startMoveTick = @lastMoveTick = null
    @input = @holdInput = @moveInput = PlayerInput.NONE
    @scoreboardView.state = @state if @scoreboardView?
    @tableView.state = @state if @tableView?
    @update()
    return
  render: ->
    @el = document.createElement 'li'
    @el.className = 'player'
    options = {@app, @game, @state, player: @}
    if @isTouchDevice
      @touchView = new PlayerTouchControlsView options
      @el.appendChild @touchView.render()
    @scoreboardView = new PlayerScoreboardView options
    @el.appendChild @scoreboardView.render()
    @tableView = new PlayerTableView options
    @el.appendChild @tableView.render()
    @el
  update: ->
    @scoreboardView?.update()
    @tableView?.update()
    return
  destroy: ->
    # Clean up child views
    @touchView?.destroy()
    delete @touchView
    @scoreboardView?.destroy()
    delete @scoreboardView
    @tableView?.destroy()
    delete @tableView
    # Clean up the DOM
    @el?.parentNode?.removeChild @el
    delete @el
    delete @state
    return
  tick: ->
    # Rate-limit holding move down
    if PlayerInput.isNone @moveInput
      @startMoveTick = @lastMoveTick = null
    else
      currentTick = @state.tickCount
      if currentTick > @startMoveTick + 4
        if currentTick > @lastMoveTick + 1
          @input = PlayerInput.set @input, @moveInput
    # Apply the input
    @state.applyInput @input
    # Clean up single button press actions
    @input = PlayerInput.clear @input, PlayerInput.PRESS_ACTIONS
    # Clean up movement actions
    moveInput = @input & PlayerInput.MOVE_ACTIONS
    unless PlayerInput.isNone moveInput
      @startMoveTick ?= @lastMoveTick = @state.tickCount
      @moveInput = moveInput
      @input = PlayerInput.clear @input, PlayerInput.MOVE_ACTIONS
    # Process the tick
    @state.tick()
    return
  actionFromEvent: (event) ->
    control = key for key, val of @controls when val is event.which
    PlayerInput.actionFromString control if control?
  beginAction: (action) ->
    unless PlayerInput.isNone action
      unless PlayerInput.get @holdInput, action
        @input = PlayerInput.set @input, action
        @holdInput = PlayerInput.set @holdInput, action
      true
    else
      false
  endAction: (action) ->
    unless PlayerInput.isNone action
      @input = PlayerInput.clear @input, action
      @holdInput = PlayerInput.clear @holdInput, action
      @moveInput = PlayerInput.clear @moveInput, action
      true
    else
      false
  handleKeyDown: (event) ->
    @beginAction @actionFromEvent event
  handleKeyUp: (event) ->
    @endAction @actionFromEvent event
