# App models
PlayerInput = require '../models/player-input'
PlayerState = require '../models/player-state'
# App views
PlayerScoreboardView = require './player-scoreboard'
PlayerStateView = require './player-state'
PlayerTouchControlsView = require './player-touch-controls'
PlayerUpNextView = require './player-up-next'

module.exports = class PlayerView
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
    options = {@app, @game, @state, player: @}
    if @isTouchDevice
      @touchView = new PlayerTouchControlsView options
      @el.appendChild @touchView.render()
    divEl = document.createElement 'div'
    divEl.className = 'player-container'
    @subviews = [
      (@scoreboardView = new PlayerScoreboardView options)
      (@upNextView = new PlayerUpNextView options)
      (@stateView = new PlayerStateView options)
    ]
    for view in @subviews
      divEl.appendChild view.render()
    @el.appendChild divEl
    @el
  update: ->
    if @subviews? then for view in @subviews
      view.update()
    return
  destroy: ->
    # Clean up child views
    @touchView?.destroy()
    delete @touchView
    if @subviews? then for view in @subviews
      view.destroy()
    delete @scoreboardView
    delete @upNextView
    delete @stateView
    delete @subviews
    # Clean up the DOM
    @el?.parentNode?.removeChild @el
    delete @el
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
    eventControl = null
    for controlName, controlInfo of @controls
      if controlInfo.type is 'keyCode'
        if controlInfo.keyCode is event.which
          eventControl = controlName
          break
    PlayerInput.actionFromString eventControl if eventControl?
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
  handleGamepad: ->
    return unless @app.isGamepadSupported
    allGamepads = navigator.getGamepads()
    for controlName, controlInfo of @controls
      if controlInfo.type is 'gamepadButton'
        controlAction = PlayerInput.actionFromString controlName
        gamepad = allGamepads[controlInfo.gamepadIndex]
        button = gamepad.buttons[controlInfo.buttonIndex]
        if button.pressed or button.value > 0
          @beginAction controlAction
        else
          @endAction controlAction
    return
