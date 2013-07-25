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
  unpause: ->
    clockRate = 1000 / @desiredFps
    @clockRef = setInterval @tick, @clockRate
    return
  pause: ->
    if @clockRef?
      clearInterval @clockRef
      @clockRef = null
    return
  tick: =>
    @game.tick()
    @view.tick()
    return
