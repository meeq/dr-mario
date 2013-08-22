# App models
GameState = require './models/game-state'
PlayerInput = require './models/player-input'
# App views
TableView = require './views/table'

module.exports = class Player
  constructor: (options) ->
    {@controls} = options
    @state = new GameState options
    return
  render: ->
    @el = document.createElement 'li'
    @el.className = 'player'
    @view = new TableView @state
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
    @state?.tick()
    @view?.update()
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
