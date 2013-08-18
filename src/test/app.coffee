Setup = require './setup'
Player = require './player'

module.exports = class TestApp
  start: ->
    setup = new Setup
      players: [(new Player 1)]
    wrapper = document.getElementById 'wrap'
    wrapper.appendChild setup.render()
    return
