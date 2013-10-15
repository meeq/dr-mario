# Core libs
{eventCharacter} = require 'core/events'
# App data
defaults = require '../defaults'

module.exports = class Setup
  # Template helpers
  template: require '../templates/setup'
  eventCharacter: eventCharacter
  soundOptions: ['on', 'off']
  musicOptions: ['fever', 'chill', 'quiet']
  speedOptions: ['lo', 'med', 'hi']
  # Child element selectors
  formSelector: 'form'
  soundSelector: '[name=sound]'
  musicSelector: '[name=music]'
  levelSelector: '[name=level]'
  speedSelector: '[name=speed]'
  controlSelector: '.controls button'
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
    # Capture form submission events
    for formEl in @el.querySelectorAll @formSelector
      formEl.addEventListener 'submit', @formSubmitted
    for radioEl in @el.querySelectorAll @soundSelector
      radioEl.addEventListener 'change', @soundChanged
    for radioEl in @el.querySelectorAll @musicSelector
      radioEl.addEventListener 'change', @musicChanged
    for rangeEl in @el.querySelectorAll @levelSelector
      rangeEl.addEventListener 'change', @levelChanged
    for radioEl in @el.querySelectorAll @speedSelector
      radioEl.addEventListener 'change', @speedChanged
    for buttonEl in @el.querySelectorAll @controlSelector
      buttonEl.addEventListener 'click', @bindControl
    @el
  destroy: ->
    # Unregister event handlers
    for formEl in @el.querySelectorAll @formSelector
      formEl.removeEventListener 'submit', @formSubmitted
    for radioEl in @el.querySelectorAll @soundSelector
      radioEl.removeEventListener 'change', @soundChanged
    for radioEl in @el.querySelectorAll @musicSelector
      radioEl.removeEventListener 'change', @musicChanged
    for rangeEl in @el.querySelectorAll @levelSelector
      rangeEl.removeEventListener 'change', @levelChanged
    for radioEl in @el.querySelectorAll @speedSelector
      radioEl.removeEventListener 'change', @speedChanged
    for buttonEl in @el.querySelectorAll @controlSelector
      buttonEl.removeEventListener 'click', @bindControl
    # Clean up the DOM
    @el?.parentNode?.removeChild @el
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
    keyCode = event.which
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
