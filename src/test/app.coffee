Timer = require './models/timer'
Player = require './player'

module.exports = class TestApp
  el: document.getElementById 'player-1'
  events:
    'keydown': 'handleKeyDown'
    'keyup': 'handleKeyUp'
  paused: true
  lastTick: null
  tickRate: 1000 / 20 # 50 ms/tick
  tickEpsilon: 5 # Max ticks per loop
  clockType: Timer.REQUEST_FRAME
  clockRef: null
  start: ->
    @players = [(new Player 1)]
    for player in @players
      @el.appendChild player.view.render()
    for eventType, handler of @events
      window.addEventListener eventType, @handleEvent, false
    return
  stop: ->
    @pause()
    for player in @players
      player.destroy()
    @players.length = 0
    for eventType, handler of @events
      window.removeEventListener eventType, @handleEvent, false
    return
  restart: ->
    @stop()
    @start()
    @unpause()
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
