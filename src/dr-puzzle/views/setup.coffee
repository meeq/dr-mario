{eventCharacter} = require '../events'
Speed = require '../models/speed'
defaults = require '../defaults'

module.exports = class Setup
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
    'change [name=level]': 'levelChanged'
    'change [name=speed]': 'speedChanged'
    'click .controls button': 'bindControl'
  constructor: ({@app, numPlayers}) ->
    @sound = @app.sound
    @music = 'quiet'
    @players = {}
    for i in [1..numPlayers]
      playerName = 'P'+i
      @players[playerName] = defaults playerName
    return
  render: ->
    @el = document.createElement 'div'
    @el.id = 'setup'
    @el.innerHTML = @template @
    # Register form event handlers
    for eventStr, callbackName of @events
      eventSplit = eventStr.indexOf ' '
      eventType = eventStr[0...eventSplit]
      eventSelector = eventStr[eventSplit+1..]
      for eventEl in @el.querySelectorAll eventSelector
        eventEl.addEventListener eventType, @[callbackName]
    @el
  destroy: ->
    # Unregister form event handlers
    for eventStr, callbackName of @events
      eventSplit = eventStr.indexOf ' '
      eventType = eventStr[0..eventSplit]
      eventSelector = eventStr[eventSplit+1..]
      for eventEl in @el.querySelectorAll eventSelector
        eventEl.removeEventListener eventType, @[callbackName]
    # Cancel binding-in-progress
    if @bindButtonEl?
      @unbindControl @bindButtonEl
      delete @bindButtonEl
    # Clean up the DOM
    if @el?
      @el.parentNode?.removeChild @el
      delete @el
    return
  soundChanged: (event) =>
    if (radioEl = event.target).checked
      switch radioEl.value
        when 'off'
          @sound?.isEnabled = false
        when 'on'
          @sound?.isEnabled = true
          @sound?.play 'move'
    return
  musicChanged: (event) =>
    if (radioEl = event.target).checked
      @music = radioEl.value
      @sound?.play 'move'
    return
  levelChanged: (event) =>
    rangeEl = event.target
    # Set the attribute so that the pseduo-element content changes
    rangeEl.setAttribute 'value', rangeEl.value
    # Update the player options
    player = @players[rangeEl.form.name]
    player.level = rangeEl.value | 0
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
    @bindButtonEl = buttonEl
    return
  unbindControl: (buttonEl) ->
    buttonEl.className = ''
    player = @players[buttonEl.form.name]
    controlName = buttonEl.name
    keyCode = player.controls[controlName]
    buttonEl.innerText = eventCharacter keyCode
    return
  handleKeyBind: (event) =>
    return unless (buttonEl = @bindButtonEl)?
    keyCode = event.keyCode ? event.which
    unless 'esc' is eventCharacter keyCode
      player = @players[buttonEl.form.name]
      controlName = buttonEl.name
      player.controls[controlName] = keyCode
    window.removeEventListener 'keydown', @handleKeyBind, false
    @unbindControl buttonEl
    delete @bindButtonEl
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
