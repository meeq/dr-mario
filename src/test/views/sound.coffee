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
  'multi-clear'
  'pause'
  'pill-clear'
  'setup'
  'speed-up'
  'taunt1'
  'taunt2'
  'victory'
  'virus-clear'
]

module.exports = class Sound
  soundsDir: '/static/sounds/test/'
  soundsExt: '.mp3'
  constructor: ->
    @audioCtx = new AudioContext()
    @buffers = {}
    @unloadedBuffers = 0
    @loadedBuffers = 0
    @loopSource = null
    @loadBuffer file, @bufferDidLoad for file in files
    return
  play: (file, isLoop) ->
    return unless @buffers[file]?
    source = @audioCtx.createBufferSource()
    source.buffer = @buffers[file]
    source.connect @audioCtx.destination
    source.start ?= source.noteOn
    source.stop ?= source.noteOff
    if isLoop
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
  loadBuffer: (file, callback) ->
    @buffers[file] = null
    @unloadedBuffers += 1
    console.log 'Loading sound file %s', file
    request = new XMLHttpRequest()
    decodeResponse = =>
      @audioCtx.decodeAudioData request.response, (buffer) =>
        @buffers[file] = buffer
        @unloadedBuffers -= 1
        @loadedBuffers += 1
        console.log 'Decoded sound buffer %s', file
        callback file
        return
      return
    url = @soundsDir + file + @soundsExt
    # Set up and send the request
    request.open 'GET', url, true
    request.responseType = 'arraybuffer'
    request.addEventListener 'load', decodeResponse, false
    request.send()
    return
  bufferDidLoad: (file) =>
    console.log 'All buffers loaded' if 0 is @unloadedBuffers
    return
