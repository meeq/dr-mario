Setup = require './setup'
Player = require './player'
Game = require './game'

module.exports = class TestApp
  wrapper: document.getElementById 'wrap'
  start: ->
    @setup = new Setup
      app: @
      numPlayers: 1
    @wrapper.appendChild @setup.render()
    return
  startGame: (options) ->
    # Clean up setup
    if @setup?
      @setup.destroy()
      delete @setup
    # Create new game
    players = []
    for playerName, playerOptions of options.players
      players.push new Player playerOptions
    @game = new Game {players}
    @wrapper.appendChild @game.render()
    @game.unpause()
    return
