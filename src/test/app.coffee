Game = require './game'
TableView = require './views/table'
Timer = require './timer'

module.exports = class TestApp
  start: ->
    @game = new Game
    @view = new TableView @game
    wrapper = document.getElementById 'wrap'
    wrapper.appendChild @view.render()
    frameRate = 1000 / @desiredFramesPerSecond
    @renderRef = Timer.start @renderType, @render, frameRate
    return
  paused: true
  desiredTicksPerSecond: 20
  clockType: Timer.INTERVAL # REQUEST_FRAME not suggested for clock ticks
  clockRef: null
  desiredFramesPerSecond: 20
  renderType: Timer.REQUEST_FRAME
  renderRef: null
  unpause: ->
    @paused = false
    clockRate = 1000 / @desiredTicksPerSecond
    @clockRef = Timer.start @clockType, @tick, clockRate
    return
  pause: ->
    @paused = true
    Timer.stop @clockType, @clockRef if @clockRef?
    @clockRef = null
    return
  tick: =>
    return if @paused
    @game.tick()
    unless Timer.isRepeating @clockType
      clockRate = 1000 / @desiredTicksPerSecond
      @clockRef = Timer.start @clockType, @tick, clockRate
    return
  render: =>
    @view.update()
    unless Timer.isRepeating @clockType
      frameRate = 1000 / @desiredFramesPerSecond
      @renderRef = Timer.start @renderType, @render, frameRate
