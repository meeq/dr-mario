SetupView = require './views/setup'
GameView = require './views/game'
Sound = require './views/sound'

module.exports = class App
  baseEl: document.body
  start: ->
    @detectBrowser()
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
    @setup = new SetupView
      app: @
      numPlayers: 1
    @baseEl.appendChild @setup.render()
    return
  startGame: (options) ->
    @cleanup()
    options.app = @
    @game = new GameView options
    @baseEl.appendChild @game.render()
    @game.unpause()
    return
  detectBrowser: ->
    {userAgent, vendor} = navigator
    isMozillaFirefox =
      (/firefox/i.test userAgent)
    isGoogleChrome =
      (/Chrome/.test userAgent) and
      (/Google Inc/.test vendor)
    isAppleMobileDevice =
      (/AppleWebKit/.test userAgent) and
      (/(iPod|iPhone|iPad)/.test userAgent)
    isAndroidMobileDevice =
      (/android/i.test userAgent)
    @isTouchDevice =
      isAppleMobileDevice or
      isAndroidMobileDevice
    @isGamepadSupported = navigator.getGamepads?
    if @isTouchDevice
      @disableBodyScrolling()
    if isMozillaFirefox
      @baseEl.className += " mozilla-firefox"
    else if isGoogleChrome
      @baseEl.className += " google-chrome"
    return
  disableBodyScrolling: ->
    document.addEventListener 'touchmove', (event) ->
      return if event.target.tagName is 'INPUT'
      event.preventDefault()
      return
    return
