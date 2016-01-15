
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

base64ToByteArray = (base64) ->
  dataUriSeparatorIndex = base64.indexOf ','
  if dataUriSeparatorIndex > -1
    base64 = base64[dataUriSeparatorIndex + 1..]
  data = atob base64
  size = data.length
  result = new Uint8Array size
  for i in [0...size]
    result[i] = data.charCodeAt i
  result

for name in files
  exports[name] = base64ToByteArray require "../sounds/" + name + ".mp3"
