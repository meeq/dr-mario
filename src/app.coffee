Setup = require './views/setup'
Game = require './views/game'
Sound = require './views/sound'

module.exports = class DrPuzzleApp
  wrapper: (document.getElementById 'wrap') ? do ->
    div = document.createElement "div"
    div.setAttribute 'id', 'wrap'
    document.body.appendChild div
    div
  start: ->
    @sound = new Sound
    if @sound.audioCtx?
      @sound.loadAll()
    else
      delete @sound
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
