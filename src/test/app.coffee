Timer = require './models/timer'
Game = require './models/game'
TableView = require './views/table'

module.exports = class TestApp
  start: ->
    @game = new Game
    @view = new TableView @game
    wrapper = document.getElementById 'wrap'
    wrapper.appendChild @view.render()
    @startRendering()
    return
  desiredFramesPerSecond: 20
  renderType: Timer.REQUEST_FRAME
  renderRef: null
  startRendering: ->
    frameRate = 1000 / @desiredFramesPerSecond
    @renderRef = Timer.start @renderType, @render, frameRate
    return
  stopRendering: ->
    Timer.stop @renderType, @renderRef if @renderRef?
    @renderRef = null
    return
  render: =>
    @view.update()
    @startRendering() unless Timer.isRepeating @renderType
    return
  paused: true
  desiredTicksPerSecond: 20
  clockType: Timer.INTERVAL # REQUEST_FRAME not suggested for clock ticks
  clockRef: null
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
    @unpause() unless Timer.isRepeating @clockType
    return
