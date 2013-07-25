GameModel = require './game-model'
GameTableView = require './game-table-view'

desiredFps = 60

module.exports = class TestApp
  start: ->
    @game = new GameModel
    @view = new GameTableView @game
    (document.getElementById 'wrap').appendChild @view.render()
    return
  clockRate: 1000 / desiredFps
  clockRef: null
  unpause: ->
    @clockRef = setInterval @tick, 1000
    return
  pause: ->
    clearInterval @clockRef
    @clockRef = null
    return
  tick: =>
    @game.tick()
    @view.tick()
    return
