# Core libs
{eventCharacter} = require 'core/events'
# App libs
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
  constructor: ({@app, @music, players}) ->
    # Cue the music!
    @sound = @app.sound
    @sound?.play @music unless @music is 'quiet'
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
    # Render player containers
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
    @lastTick ?= Timer.now()
    @clockRef = Timer.start @clockType, @loop, @tickRate
    return
  pause: ->
    @sound?.play 'pause'
    @paused = true
    @lastTick = null
    Timer.stop @clockType, @clockRef if @clockRef?
    @clockRef = null
    return
  loop: =>
    return if @paused
    # Figure out how many ticks have happened since the last loop
    now = Timer.now()
    deltaTicks = (now - @lastTick) / @tickRate | 0
    if deltaTicks and deltaTicks <= @tickEpsilon
      # Update the player states
      for tick in [0...deltaTicks]
        for player in @players
          player.tick()
      # Only update the UI once
      for player in @players
        player.update()
      @lastTick = now
    # Schedule the next loop
    @unpause() unless Timer.isRepeating @clockType
    return
  handleEvent: (event) =>
    if eventHandlerKey = @events[event.type]
      # Check if the game handles the key
      isEventHandled = @[eventHandlerKey]?(event) ? false
      # Check if any of the players have the key bound
      for player in @players when not isEventHandled
        isEventHandled = player[eventHandlerKey]?(event) ? false
      if isEventHandled and not event.metaKey # Preserve browser hotkeys
        event.preventDefault()
        return false
    return
  handleKeyDown: (event) ->
    switch (eventCharacter event)
      when 'p'
        return true
    false
  handleKeyUp: (event) ->
    switch (eventCharacter event)
      when 'p'
        if @paused then @unpause() else @pause()
        return true
    false
  playerDidSpawnCapsule: (player) ->
    # TODO
  playerDidMoveCapsule: (player) ->
    @sound?.play 'move'
    return
  playerDidRotateCapsule: (player) ->
    @sound?.play 'flip'
    return
  playerDidWriteCellsToGrid: (player, numCells) ->
    @sound?.play 'drop'
    return
  playerDidSpeedUp: (player) ->
    @sound?.play 'speed-up'
    return
  playerDidMarkLines: (player, numLines, numViruses, didClearColor) ->
    if didClearColor
      @sound?.play 'color-clear'
    else if numViruses
      @sound?.play 'virus-clear'
    else
      @sound?.play 'pill-clear'
    if numLines > 1 and @players.length > 1
      console.log 'Marked %d lines; attacking!', numLines
      # TODO Multi-player attack buffer
    return
  playerDidClearMarked: (player, numCells, numViruses) ->
    # TODO
  playerDidEndGame: (player, isVictory) ->
    @sound?.stopLoop()
    if isVictory
      console.log 'You win!'
      # TODO Show Next / Setup buttons
      @sound?.play 'victory'
    else
      console.log 'Game over!'
      # TODO Show Retry / Setup buttons
      @sound?.play 'game-over'
    return
