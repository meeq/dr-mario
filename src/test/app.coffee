Game = require './game'
TableView = require './views/table'

module.exports = class TestApp
  start: ->
    @game = new Game
    @view = new TableView @game
    wrapper = document.getElementById 'wrap'
    wrapper.appendChild @view.render()
    return
  desiredFps: 1
  clockRef: null
  paused: true
  unpause: ->
    @paused = false
    clockRate = 1000 / @desiredFps
    @clockRef = setTimeout @tick, clockRate
    return
  pause: ->
    @paused = true
    if @clockRef?
      clearTimeout @clockRef
      @clockRef = null
    return
  tick: =>
    @game.tick()
    @view.tick()
    @unpause() unless @paused
    return
