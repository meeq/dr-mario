setter = (klass, prop, set) ->
  Object.defineProperty klass.prototype, prop, {set, configurable: true}

PlayerMatrixView = require './player-matrix'

module.exports = class PlayerUpNextView
  setter @, 'state', (state) ->
    {capsule} = state
    {@nextBuffer} = capsule
    return
  constructor: (options) ->
    @state = options.state
    return
  render: ->
    @el = document.createElement 'aside'
    @el.className = 'player-up-next'
    @matrixView = new PlayerMatrixView buffer: @nextBuffer
    @el.appendChild @matrixView.render()
    @update()
    @el
  destroy: ->
    @matrixView?.destroy()
    delete @matrixView
    # Clean up the DOM
    @el?.parentNode?.removeChild @el
    delete @el
    return
  update: ->
    @matrixView?.update()
    return
