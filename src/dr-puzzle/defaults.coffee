# Core libs
{stringKeyCode} = require 'core/events'

module.exports = (playerName) ->
  level: 10
  speed: 'med'
  controls:
    'Move Left':      stringKeyCode 'left'
    'Move Right':     stringKeyCode 'right'
    'Flip Left':      stringKeyCode 'Z'
    'Flip Right':     stringKeyCode 'X'
    'Fast Drop':      stringKeyCode 'down'
    'Instant Drop':   stringKeyCode 'up'
    # 'Hold Next':      stringKeyCode 'shift'
    # 'Flip Attack':    stringKeyCode 'ctrl'
