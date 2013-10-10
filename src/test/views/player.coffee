# App models
PlayerInput = require '../models/player-input'
PlayerState = require '../models/player-state'
# App views
TableView = require './table'

module.exports = class Player
  constructor: (options) ->
    {@controls} = options
    @state = new PlayerState options
    @startMoveTick = @lastMoveTick = null
    @input = @holdInput = @moveInput = PlayerInput.NONE
    return
  render: ->
    @el = document.createElement 'li'
    @el.className = 'player'
    @view = new TableView @state
    @el.appendChild @view.render()
    @el
  update: ->
    @view?.update()
    return
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
  handleKeyDown: (event) ->
    if action = @actionFromEvent event
      unless PlayerInput.get @holdInput, action
        @input = PlayerInput.set @input, action
        @holdInput = PlayerInput.set @holdInput, action
      true
    else false
  handleKeyUp: (event) ->
    if action = @actionFromEvent event
      @input = PlayerInput.clear @input, action
      @holdInput = PlayerInput.clear @holdInput, action
      @moveInput = PlayerInput.clear @moveInput, action
      true
    else false
