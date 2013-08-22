Setup = require './views/setup'
Player = require './views/player'
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
    players = []
    for playerName, playerOptions of options.players
      players.push new Player playerOptions
    @game = new Game
      app: @
      players: players
    @wrapper.appendChild @game.render()
    @game.unpause()
    return
