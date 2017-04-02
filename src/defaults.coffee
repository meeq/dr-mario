{stringKeyCode} = require './events'

exports.keyCodeControl = keyCodeControl = (keyCode) ->
  keyCode = stringKeyCode keyCode if typeof keyCode is 'string'
  { type: 'keyCode', keyCode }

exports.gamepadButtonControl = (gamepadIndex, buttonIndex) ->
  { type: 'gamepadButton', gamepadIndex, buttonIndex }

exports.player = (playerName) ->
  level: 10
  speed: 'med'
  controls:
    'Move Left':      keyCodeControl 'left'
    'Move Right':     keyCodeControl 'right'
    'Flip Left':      keyCodeControl 'Z'
    'Flip Right':     keyCodeControl 'X'
    'Fast Drop':      keyCodeControl 'down'
    'Instant Drop':   keyCodeControl 'up'
    # 'Hold Next':      keyCodeControl 'shift'
    # 'Flip Attack':    keyCodeControl 'ctrl'
