Timer = require './models/timer'
Player = require './models/player'

COMMAND_KEYCODE = 91

module.exports = class TestApp
  paused: true
  lastTick: null
  tickRate: 1000 / 20 # 50 ms/tick
  tickEpsilon: 2 # Max ticks per loop
  clockType: Timer.REQUEST_FRAME
  clockRef: null
  eventListenerTypes: ['keydown', 'keyup']
  start: ->
    @players = [new Player 1]
    wrapper = document.getElementById 'wrap'
    for player in @players
      wrapper.appendChild player.view.render()
    for eventType in @eventListenerTypes
      window.addEventListener eventType, @handleEvent, false
    return
  stop: ->
    @pause()
    player.destroy() for player in @players
    @players.length = 0
    for eventType in @eventListenerTypes
      window.removeEventListener eventType, @handleEvent, false
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
    eventTypeHandlerKey = null
    switch event.type
      when 'keydown'
        eventTypeHandlerKey = 'handleKeyDown'
      when 'keyup'
        eventTypeHandlerKey = 'handleKeyUp'
    if eventTypeHandlerKey?
      isEventHandled = @[eventTypeHandlerKey]?(event) ? false
      for player in @players when not isEventHandled
        isEventHandled = player[eventTypeHandlerKey]?(event) ? false
      event.preventDefault() if isEventHandled
    return
  handleKeyDown: (event) ->
  handleKeyUp: (event) ->
