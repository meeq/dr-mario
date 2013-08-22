# Core libs
{eventCharacter} = require 'core/events'
# App data
defaults = require '../defaults'

module.exports = class Setup
  template: require '../templates/setup'
  eventCharacter: eventCharacter
  speedOptions: ['lo', 'med', 'hi']
  formSelector: 'form'
  levelSelector: '[name=level]'
  speedSelector: '[name=speed]'
  controlSelector: '.controls button'
  constructor: ({@app, numPlayers}) ->
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
    for rangeEl in @el.querySelectorAll @levelSelector
      rangeEl.addEventListener 'change', @levelChanged
    for radioEl in @el.querySelectorAll @speedSelector
      radioEl.addEventListener 'change', @speedChanged
    for buttonEl in @el.querySelectorAll @controlSelector
      # TODO Listen for and handle button clicks
      buttonEl.addEventListener
    @el
  destroy: ->
    # Unregister event handlers
    for formEl in @el.querySelectorAll @formSelector
      formEl.removeEventListener 'submit', @formSubmitted
    for rangeEl in @el.querySelectorAll @levelSelector
      rangeEl.removeEventListener 'change', @levelChanged
    for radioEl in @el.querySelectorAll @speedSelector
      radioEl.removeEventListener 'change', @speedChanged
    for buttonEl in @el.querySelectorAll @controlSelector
      # TODO Remove button click listener
      buttonEl.removeEventListener
    # Clean up the DOM
    @el?.parentNode?.removeChild @el
    delete @el
    return
  levelChanged: (event) =>
    rangeEl = event.target
    # Set the attribute so that the pseduo-element content changes
    rangeEl.setAttribute 'value', rangeEl.value
    # Update the player options
    player = @players[rangeEl.form.name]
    player.level = rangeEl.value | 0
    return
  speedChanged: (event) =>
    if (radioEl = event.target).checked
      # Update the player options
      player = @players[radioEl.form.name]
      player.speed = radioEl.value
    return
  formSubmitted: (event) =>
    formEl = event.target
    player = @players[formEl.name]
    player.isReady = true
    @startRef = setTimeout @maybeStartGame unless @startRef?
    event.preventDefault()
    false
  maybeStartGame: =>
    delete @startRef
    isReady = true
    for playerName, player of @players
      isReady = isReady and player.isReady
    @app.startGame {@players} if isReady
    return
