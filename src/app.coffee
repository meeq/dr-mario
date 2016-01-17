Setup = require './views/setup'
Game = require './views/game'
Sound = require './views/sound'

module.exports = class DrPuzzleApp
  isTouchDevice: do ->
    {userAgent} = navigator
    (/(iPod|iPhone|iPad)/.test userAgent) and
    (/AppleWebKit/.test userAgent)
  baseEl: document.body
  start: ->
    if @isTouchDevice
      @disableBodyScrolling()
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
    @baseEl.appendChild @setup.render()
    return
  startGame: (options) ->
    @cleanup()
    options.app = @
    @game = new Game options
    @baseEl.appendChild @game.render()
    @game.unpause()
    return
  disableBodyScrolling: ->
    document.addEventListener 'touchmove', (event) ->
      return if event.target.tagName is 'INPUT'
      event.preventDefault()
      return
    return
