Timer = require '../models/timer'
Player = require './player'

module.exports = class Game
  events:
    'keydown': 'handleKeyDown'
    'keyup': 'handleKeyUp'
  paused: true
  lastTick: null
  tickRate: 1000 / 30 # 30 frames/sec
  tickEpsilon: 5 # Max ticks per loop
  clockType: Timer.REQUEST_FRAME
  clockRef: null
  constructor: ({@app, players}) ->
    # Create players from options
    @players = []
    for playerName, options of players
      options.game = @
      @players.push new Player options
    # Register event handlers
    for eventType, handler of @events
      window.addEventListener eventType, @handleEvent, false
    return
  render: ->
    @el = document.createElement 'ul'
    @el.id = 'game'
    for player in @players
      @el.appendChild player.render()
    @el
  destroy: ->
    # Stop timer
    @pause()
    # Clean up players
    for player in @players
      player.destroy()
    delete @players
    # Clean up view
    @el?.parentNode?.removeChild @el
    delete @el
    # Unregister event handlers
    for eventType, handler of @events
      window.removeEventListener eventType, @handleEvent, false
    return
  unpause: ->
    @paused = false
    @lastTick = Date.now() unless @lastTick?
    @clockRef = Timer.start @clockType, @loop, @tickRate
    return
  pause: ->
    @paused = true
    @lastTick = null
    Timer.stop @clockType, @clockRef if @clockRef?
    @clockRef = null
    return
  loop: =>
    return if @paused
    now = Date.now()
    deltaTicks = (now - @lastTick) / @tickRate | 0
    if deltaTicks and deltaTicks <= @tickEpsilon
      for tick in [0...deltaTicks]
        for player in @players
          player.tick()
      @lastTick = now
    @unpause() unless Timer.isRepeating @clockType
    return
  playerDidEndGame: (player) ->
    return
  playerDidMarkLines: (player) ->
    return
  playerDidSpeedUp: (player) ->
    return
  handleEvent: (event) =>
    if eventHandlerKey = @events[event.type]
      isEventHandled = @[eventHandlerKey]?(event) ? false
      for player in @players when not isEventHandled
        isEventHandled = player[eventHandlerKey]?(event) ? false
      if isEventHandled and not event.metaKey # Preserve browser hotkeys
        event.preventDefault()
        return false
    return
  handleKeyDown: (event) ->
    # TODO
  handleKeyUp: (event) ->
    # TODO
