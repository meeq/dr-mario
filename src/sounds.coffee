
files = [
  'chill'
  'defeat'
  'drop'
  'fever'
  'flip'
  'game-over'
  'match-over'
  'menu'
  'move'
  'color-clear'
  'pause'
  'pill-clear'
  'setup'
  'speed-up'
  'taunt1'
  'taunt2'
  'victory'
  'virus-clear'
]

for name in files
  exports[name] = require("../sounds/" + name + ".mp3")
