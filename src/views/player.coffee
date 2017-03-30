# App models
PlayerInput = require '../models/player-input'
PlayerState = require '../models/player-state'
# App views
PlayerScoreboardView = require './player-scoreboard'
PlayerStateView = require './player-state'
PlayerTouchControlsView = require './player-touch-controls'
PlayerUpNextView = require './player-up-next'

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
    if @subviews? then for view in @subviews
      view.state = @state
    @update()
    return
  render: ->
    @el = document.createElement 'li'
    @el.className = 'player'
    @subviews = []
    options = {@app, @game, @state, player: @}
    if @isTouchDevice
      @subviews.push @touchView = new PlayerTouchControlsView options
    @subviews.push @scoreboardView = new PlayerScoreboardView options
    @subviews.push @upNextView = new PlayerUpNextView options
    @subviews.push @stateView = new PlayerStateView options
    for view in @subviews
      @el.appendChild view.render()
    @el
  update: ->
    if @subviews? then for view in @subviews
      view.update()
    return
  destroy: ->
    # Clean up child views
    if @subviews? then for view in @subviews
      view.destroy()
    delete @touchView
    delete @scoreboardView
    delete @upNextView
    delete @stateView
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
