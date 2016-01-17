AudioContext = window.AudioContext ? window.webkitAudioContext

musicLoopOffsets =
  'menu': 0
  'setup': 0
  'fever': 3.189
  'chill': 7.421

module.exports = class Sound
  constructor: ->
    @isEnabled = false
    @audioCtx = new AudioContext if AudioContext?
    @buffers = {}
    @unloadedBuffers = 0
    @loadedBuffers = 0
    @lastSource = null
    @loopSource = null
    return
  play: (file) ->
    return unless @audioCtx? and @isEnabled and @buffers[file]?
    source = @audioCtx.createBufferSource()
    source.buffer = @buffers[file]
    source.connect @audioCtx.destination
    source.start ?= source.noteOn
    source.stop ?= source.noteOff
    if musicLoopOffsets[file]?
      @stopLoop()
      @loopSource = source
      source.loop = true
      source.loopStart = musicLoopOffsets[file]
    source.start 0
    @lastSource = source
    return
  stopLast: ->
    if @lastSource?
      @lastSource.stop 0
      @lastSource = null
    return
  stopLoop: ->
    if @loopSource?
      @loopSource.stop 0
      @loopSource = null
    return
  loadAll: (done) ->
    if done? then bufferDidLoad = =>
      done() if 0 is @unloadedBuffers
    (require '../sounds').loadAll (sounds) =>
      for file, data of sounds
        @decodeAudioData file, data, bufferDidLoad
      return
    return
  decodeAudioData: (file, data, done) ->
    @buffers[file] = null
    @unloadedBuffers += 1
    onSuccess = (buffer) =>
      @buffers[file] = buffer
      @unloadedBuffers -= 1
      @loadedBuffers += 1
      done?(file)
      return
    onFailure = =>
      @unloadedBuffers -= 1
      done?(file)
      return
    @audioCtx.decodeAudioData data, onSuccess, onFailure
    return
