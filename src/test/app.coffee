Setup = require './views/setup'
Game = require './views/game'

module.exports = class TestApp
  wrapper: document.getElementById 'wrap'
  start: ->
    @showSetup()
    return
  cleanup: ->
    if @setup?
      @setup.destroy()
      delete @setup
    if @game?
      @game.destroy()
      delete @game
    return
  showSetup: ->
    @cleanup()
    @setup = new Setup
      app: @
      numPlayers: 1
    @wrapper.appendChild @setup.render()
    return
  startGame: (options) ->
    @cleanup()
    options.app = @
    @game = new Game options
    @wrapper.appendChild @game.render()
    @game.unpause()
    return
