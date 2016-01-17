
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

fileExt = '.mp3'
dataUriPrefix = 'data:audio/mpeg;base64,'

base64ToByteArray = (base64) ->
  data = atob base64
  size = data.length
  result = new Uint8Array size
  for i in [0...size]
    result[i] = data.charCodeAt i
  result

loadFile = (file, done) ->
  request = new XMLHttpRequest()
  request.open 'GET', file, true
  request.responseType = 'arraybuffer'
  request.addEventListener 'load', -> done request.response
  request.send()
  return

loadAll = (done) ->
  result = {}
  numLoaded = 0
  maybeDone = ->
    if numLoaded is files.length
      done result
    return
  maybeDoneAfterLoad = (name) ->
    (response) ->
      result[name] = response
      numLoaded += 1
      maybeDone()
      return
  for name in files
    file = require "../sounds/" + name + fileExt
    # Request file from server
    if file[-fileExt.length..] is fileExt
      loadFile file, maybeDoneAfterLoad name
    # Parse base64 data URIs into Uint8Arrays
    else if file[...dataUriPrefix.length] is dataUriPrefix
      data = base64ToByteArray file[dataUriPrefix.length..]
      result[name] = data.buffer
      numLoaded += 1
  maybeDone()
  return

module.exports = {
  base64ToByteArray
  loadFile
  loadAll
  files
}
