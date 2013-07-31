Timer = require './models/timer'
Player = require './player'

module.exports = class TestApp
  el: document.getElementById 'wrap'
  paused: true
  lastTick: null
  tickRate: 1000 / 20 # 50 ms/tick
  tickEpsilon: 2 # Max ticks per loop
  clockType: Timer.REQUEST_FRAME
  clockRef: null
  eventListenerHandlers:
    'keydown': 'handleKeyDown'
    'keyup': 'handleKeyUp'
  start: ->
    @players = [(new Player 1)]
    for player in @players
      @el.appendChild player.view.render()
    for eventType, handler of @eventListenerHandlers
      window.addEventListener eventType, @handleEvent, false
    return
  stop: ->
    @pause()
    for player in @players
      player.destroy()
    @players.length = 0
    for eventType, handler of @eventListenerHandlers
      window.removeEventListener eventType, @handleEvent, false
    return
  restart: ->
    @stop()
    @start()
    @unpause()
    return
  unpause: ->
    @paused = false
    @lastTick = +new Date unless @lastTick?
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
    now = +new Date
    deltaTicks = (now - @lastTick) / @tickRate | 0
    if deltaTicks and deltaTicks <= @tickEpsilon
      for tick in [0...deltaTicks]
        for player in @players
          player.tick()
      @lastTick = now
    @unpause() unless Timer.isRepeating @clockType
    return
  handleEvent: (event) =>
    return if event.metaKey # Gotta preserve the important browser hotkeys.
    isEventHandled = false
    if eventTypeHandlerKey = @eventListenerHandlers[event.type]
      console.log eventTypeHandlerKey, event.which
      isEventHandled = @[eventTypeHandlerKey]?(event) ? false
      for player in @players when not isEventHandled
        isEventHandled = player[eventTypeHandlerKey]?(event) ? false
      if isEventHandled
        event.preventDefault()
        return false
    return
  handleKeyDown: (event) ->
    # TODO
  handleKeyUp: (event) ->
    # TODO
