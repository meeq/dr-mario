AudioContext = window.AudioContext ? window.webkitAudioContext

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

loops = [
  'menu'
  'setup'
  'chill'
  'fever'
]

module.exports = class Sound
  soundsDir: '/static/sounds/test/'
  soundsExt: '.mp3'
  constructor: ->
    @isEnabled = false
    @audioCtx = new AudioContext if AudioContext?
    @buffers = {}
    @unloadedBuffers = 0
    @loadedBuffers = 0
    @loopSource = null
    return
  play: (file) ->
    return unless @audioCtx? and @isEnabled and @buffers[file]?
    source = @audioCtx.createBufferSource()
    source.buffer = @buffers[file]
    source.connect @audioCtx.destination
    source.start ?= source.noteOn
    source.stop ?= source.noteOff
    if file in loops
      @stopLoop()
      @loopSource = source
      source.loop = true
    source.start 0
    return
  stopLoop: ->
    if @loopSource?
      @loopSource.stop 0
      @loopSource = null
    return
  loadAll: (callback) ->
    if callback?
      bufferDidLoad = =>
        callback() if 0 is @unloadedBuffers
    for file in files
      @loadBuffer file, bufferDidLoad
    return
  loadBuffer: (file, callback) ->
    @buffers[file] = null
    @unloadedBuffers += 1
    request = new XMLHttpRequest
    decodeResponse = =>
      onSuccess = (buffer) =>
        @buffers[file] = buffer
        @unloadedBuffers -= 1
        @loadedBuffers += 1
        callback?(file)
        return
      onFailure = =>
        @unloadedBuffers -= 1
        callback?(file)
        return
      @audioCtx.decodeAudioData request.response, onSuccess, onFailure
      return
    url = @soundsDir + file + @soundsExt
    # Set up and send the request
    request.open 'GET', url, true
    request.responseType = 'arraybuffer'
    request.addEventListener 'load', decodeResponse, false
    request.send()
    return
