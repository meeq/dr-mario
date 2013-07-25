GameModel = require './game-model'
GameTableView = require './game-table-view'

module.exports = class TestApp
  start: ->
    @game = new GameModel
    @view = new GameTableView @game
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
