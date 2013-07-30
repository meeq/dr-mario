Timer = require './models/timer'
Game = require './models/game'
TableView = require './views/table'

module.exports = class TestApp
  paused: true
  lastTick: null
  tickRate: 1000 / 20 # 50 ms/tick
  tickEpsilon: 1000 # 1 second
  clockType: Timer.INTERVAL
  clockRef: null
  start: ->
    @game = new Game
    @view = new TableView @game
    wrapper = document.getElementById 'wrap'
    wrapper.appendChild @view.render()
    return
  stop: ->
    @pause()
    delete @game
    @view.destroy() if @view?
    delete @view
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
    delta = now - @lastTick
    if delta < @tickEpsilon
      numTicks = delta / @tickRate | 0
      @game.tick() for i in [0...numTicks]
    @view.update()
    @lastTick = now if numTicks? and numTicks > 0
    @unpause() unless Timer.isRepeating @clockType
    return
