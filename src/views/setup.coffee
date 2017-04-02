{eventCharacter} = require '../events'
Speed = require '../models/speed'
Timer = require '../models/timer'
Defaults = require '../defaults'

{keyCodeControl, gamepadButtonControl} = Defaults

module.exports = class SetupView
  # Template helpers
  template: require '../templates/setup'
  eventCharacter: eventCharacter
  soundOptions: ['on', 'off']
  musicOptions: ['fever', 'chill', 'quiet']
  speedOptions: Speed.options
  # Child element selectors
  events:
    'submit form': 'formSubmitted'
    'change [name=sound]': 'soundChanged'
    'change [name=music]': 'musicChanged'
    'input [name=level]': 'levelChanged'
    'change [name=level]': 'levelChanged'
    'change [name=speed]': 'speedChanged'
    'click .controls button': 'bindControl'
  constructor: ({@app, numPlayers}) ->
    {@isTouchDevice, @sound} = @app
    @music = 'quiet'
    @players = {}
    for i in [1..numPlayers]
      playerName = 'P'+i
      @players[playerName] = Defaults.player playerName
    return
  render: ->
    # Setup the sound
    @sound?.stopLoop()
    @sound?.play 'setup' if @sound?.isEnabled
    # Create the view
    @el = document.createElement 'div'
    @el.id = 'setup'
    @el.innerHTML = @template @
    @registerEventHandlers()
    # Setup initial form state
    soundValue = if @sound?.isEnabled then 'on' else 'off'
    (@el.querySelector "[id=sound-#{soundValue}]").checked = true
    (@el.querySelector "[id=music-#{@music}]").checked = true
    for playerName, player of @players
      playerEl = @el.querySelector "[name=#{playerName}]"
      (playerEl.querySelector "[name=level]").value = player.level
      (playerEl.querySelector "[id=speed-#{player.speed}]").checked = true
      # Set all of the button labels to the corresponding mapped input
      for buttonEl in (playerEl.querySelectorAll '.controls button')
        @updateButtonFromControl buttonEl
    @el
  destroy: ->
    # Stop the music
    @sound?.stopLoop()
    # Tear down elements and events
    if @el?
      @unregisterEventHandlers()
      # Cancel binding-in-progress
      @cleanupBindControl() if @bindButtonEl?
      # Clean up the DOM
      @el.parentNode?.removeChild @el
      delete @el
    return
  registerEventHandlers: ->
    # Register form event handlers
    for eventStr, callbackName of @events
      eventSplit = eventStr.indexOf ' '
      eventType = eventStr[0...eventSplit]
      eventSelector = eventStr[eventSplit+1..]
      for eventEl in @el.querySelectorAll eventSelector
        eventEl.addEventListener eventType, @[callbackName]
    document.addEventListener 'visibilitychange', @handleVisibilityChange
    return
  unregisterEventHandlers: ->
    # Unregister form event handlers
    for eventStr, callbackName of @events
      eventSplit = eventStr.indexOf ' '
      eventType = eventStr[0..eventSplit]
      eventSelector = eventStr[eventSplit+1..]
      for eventEl in @el.querySelectorAll eventSelector
        eventEl.removeEventListener eventType, @[callbackName]
    document.removeEventListener 'visibilitychange', @handleVisibilityChange
    return
  handleVisibilityChange: (event) =>
    if document.hidden
      @sound?.stopLoop()
    else
      @sound?.play 'setup' if @sound?.isEnabled
    return
  soundChanged: (event) =>
    if (radioEl = event.target).checked
      switch radioEl.value
        when 'off'
          @sound?.isEnabled = false
          @sound.stopLoop()
        when 'on'
          @sound?.isEnabled = true
          @sound?.play 'move'
          @sound?.play 'setup'
    return
  musicChanged: (event) =>
    if (radioEl = event.target).checked
      @music = radioEl.value
      @sound?.play 'move'
    return
  levelChanged: (event) =>
    rangeEl = event.target
    rangeVal = rangeEl.value | 0
    # Set the attribute so that the pseduo-element content changes
    rangeEl.setAttribute 'value', rangeVal
    # Update the player options
    player = @players[rangeEl.form.name]
    if player.level isnt rangeVal
      player.level = rangeVal
      @sound?.play 'move'
    return
  speedChanged: (event) =>
    if (radioEl = event.target).checked
      # Update the player options
      player = @players[radioEl.form.name]
      player.speed = radioEl.value
      @sound?.play 'move'
    return
  bindControl: (event) =>
    buttonEl = event.target
    buttonEl.className = 'bind'
    buttonEl.innerText = 'bind'
    if @bindButtonEl?
      @unbindControl @bindButtonEl
    else
      window.addEventListener 'keydown', @handleKeyBind, false
      @startGamepadBindTimer()
    @bindButtonEl = buttonEl
    return
  cleanupBindControl: ->
    window.removeEventListener 'keydown', @handleKeyBind, false
    if @bindControllerTimerRef?
      Timer.stop Timer.REQUEST_FRAME, @bindControllerTimerRef
      delete @bindControllerTimerRef
    @unbindControl @bindButtonEl
    delete @bindButtonEl
    return
  unbindControl: (buttonEl) ->
    buttonEl.className = ''
    @updateButtonFromControl buttonEl
    return
  updateButtonFromControl: (buttonEl) ->
    player = @players[buttonEl.form.name]
    controlInfo = player.controls[buttonEl.name]
    buttonEl.innerText =
      switch controlInfo.type
        when 'keyCode'
          eventCharacter controlInfo.keyCode
        when 'gamepadButton'
          "P#{controlInfo.gamepadIndex + 1} B#{controlInfo.buttonIndex}"
        else
          "unbound"
    return
  handleKeyBind: (event) =>
    return unless (buttonEl = @bindButtonEl)?
    keyCode = event.keyCode ? event.which
    unless 'esc' is eventCharacter keyCode
      player = @players[buttonEl.form.name]
      boundControl = keyCodeControl keyCode
      player.controls[buttonEl.name] = boundControl
    @cleanupBindControl()
    return
  startGamepadBindTimer: ->
    if @app.isGamepadSupported
      # Listen for button presses on gamepads
      timerType = Timer.REQUEST_FRAME
      timerRate = (1000 / 30) # 30hz
      @bindGamepadRef = Timer.start timerType, @handleGamepadBind, timerRate
    return
  handleGamepadBind: =>
    return unless (buttonEl = @bindButtonEl)?
    bindGamepadIndex = null
    bindButtonIndex = null
    for gamepad in navigator.getGamepads() when gamepad?.connected
      if bindGamepadIndex? and bindButtonIndex?
        break
      for button, buttonIndex in gamepad.buttons
        if button.pressed or button.value > 0
          bindGamepadIndex = gamepad.index
          bindButtonIndex = buttonIndex
          break
    if bindGamepadIndex? and bindButtonIndex?
      player = @players[buttonEl.form.name]
      boundControl = gamepadButtonControl bindGamepadIndex, bindButtonIndex
      player.controls[buttonEl.name] = boundControl
      @cleanupBindControl()
    else
      @startGamepadBindTimer()
    return
  formSubmitted: (event) =>
    formEl = event.target
    player = @players[formEl.name]
    unless player?.isReady
      player.isReady = true
      submitEl = formEl.querySelector 'button[type=submit]'
      submitEl.disabled = true
      submitEl.innerText = 'Ready!'
      @startRef = setTimeout @maybeStartGame unless @startRef?
    event.preventDefault()
    false
  maybeStartGame: =>
    delete @startRef
    isReady = true
    for playerName, player of @players
      isReady = isReady and player.isReady
    @app.startGame {@music, @players} if isReady
    return
