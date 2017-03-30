Timer = require '../models/timer'
PlayerMatrixView = require './player-matrix'

tickClassName = 'player-state tick'
tockClassName = 'player-state tock'

module.exports = class PlayerStateView
  lastTick: null
  tickRate: 250
  constructor: ({@state}) ->
    @lastTick = Timer.now()
    return
  render: ->
    @el = document.createElement 'figure'
    @el.className = tickClassName
    @matrixView = new PlayerMatrixView {@state}
    @el.appendChild @matrixView.render()
    @update()
    @el
  destroy: ->
    @matrixView?.destroy()
    delete @matrixView
    # Clean up DOM
    @el?.parentNode?.removeChild @el
    delete @el
    return
  update: ->
    @matrixView?.update()
    # Update animations
    now = Timer.now()
    if @lastTick + @tickRate < now
      @lastTick = now
      if @el.className isnt tickClassName
        @el.className = tickClassName
      else
        @el.className = tockClassName
    return
